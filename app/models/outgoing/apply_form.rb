module Outgoing
  class ApplyForm < ::ApplyForm

    validates_presence_of :volunteer
    delegate :asked, :accepted, :rejected, :rejected?, :infosheeted, :to => :current_assignment, :allow_nil => true

    belongs_to :volunteer, :class_name => 'Volunteer'
    belongs_to :current_workcamp, :foreign_key => 'current_workcamp_id_cached', :class_name => 'Outgoing::Workcamp'
    belongs_to :current_assignment, :foreign_key => 'current_assignment_id_cached', :class_name => 'Outgoing::WorkcampAssignment'

    has_one :payment, :dependent => :nullify, :select => 'id, apply_form_id, amount, returned_amount, received, returned_date, return_reason'
    has_many :workcamps, :through => :workcamp_assignments, :order => 'workcamp_assignments."order" ASC', :class_name => 'Outgoing::Workcamp'
    has_many :workcamp_assignments, :dependent => :delete_all, :order => '"order" ASC', :class_name => 'Outgoing::WorkcampAssignment'



    # TODO - retrieve from parameter and check for other apply forms
    def after_initialize
      self.fee ||= 2200
    end

    # FIXME - this is a hack to overcome new template system difficulties
    def workcamps_list
      result = ''

      self.reload.workcamps.each_with_index do |wc,i|
        result += "#{i+1}) #{wc.code} - #{wc.name}"
        result += " od #{wc.begin_string} do #{wc.end_string}\n" rescue ''
      end

      result
    end


    def self.state_filter(state)
      wa = Outgoing::WorkcampAssignment.table_name
      filter_sql = ''
      filter_params = []

      case state
      when "alerts"
          filter_sql << '('
        filter_sql << " ((#{wa}.asked <= ?) AND #{wa}.accepted IS NULL AND #{wa}.rejected IS NULL and cancelled IS NULL)"
        filter_sql << ' OR '
        filter_sql << " (cancelled IS NULL AND #{wa}.accepted IS NOT NULL AND #{wa}.infosheeted IS NULL AND #{Workcamp.table_name}.\"begin\" <= ?)"
        filter_sql << ')'
        filter_params << InexRules.organization_response_limit
        filter_params << InexRules.infosheet_waiting_limit

      when "cancelled"
          filter_sql <<  ' cancelled IS NOT NULL'

      when "asked"
          filter_sql << " #{wa}.asked IS NOT NULL AND #{wa}.accepted IS NULL AND #{wa}.rejected IS NULL and cancelled IS NULL"

      when "accepted"
          filter_sql << " cancelled IS NULL AND #{wa}.accepted IS NOT NULL"

      when "rejected"
          filter_sql << " cancelled IS NULL AND #{wa}.rejected IS NOT NULL"
      when "pending"
          filter_sql << " payments.id IS NOT NULL AND #{wa}.asked IS NULL AND #{wa}.accepted IS NULL and #{wa}.rejected IS NULL AND cancelled IS NULL"
      when "without_payment"
        filter_sql << ' payments.id IS NULL'
      end

      [ filter_sql ].concat(filter_params)
    end

    def self.find_records_like(text)
      search = '%' + text.downcase + '%'
      self.find(:all,
                :conditions => ['lower(people.lastname) LIKE ?', search],
                :include => :volunteer,
                :order => 'people.lastname ASC',
                :limit => 15)
    end

    # Returns list of possible actions for the Apply Form
    def actions
      state.actions
    end

    def state
      ApplyFormState.create(self)
    end

    def last_workcamp
      workcamps.find(:first, :order => '"order" DESC')
    end

    def accepted?
      self.accepted and self.cancelled.nil?
    end

    def paid?
      payment and (payment.amount == self.fee)
    end

    def is?(state)
      self.state.name == state
    end

    # TODO - use Proc, Method or at least define_method
    [ "accept", "reject", "ask", "infosheet" ].each do |action|
      eval %{
        def #{action}(time = nil)
          raise "This apply form has no current assignment, cannot run action #{action}" unless self.current_assignment
          current_assignment.#{action}(time)
            self.reload
        end
      }
    end

    ##############################################################
    # TODO - move to library?
    ##############################################################

    class NoWorkcampError < StandardError
    end

    class InvalidModelError < StandardError
      attr_reader :model
      def initialize(model)
        super
        @model = model
      end
    end

    MAIL_FAILED_TAG = 'mail problems'
    POSSIBLE_DUPLICATE = 'duplicate volunteer?'

    FORM_ATTRS = [ :general_remarks, :motivation ]
    VOLUNTEER_ATTRS = [
                       :firstname, :lastname, :gender,
                       :email, :phone,
                       :birthdate, :birthnumber,
                       :nationality, :occupation,
                       :street, :city, :zipcode,
                       :contact_street, :contact_city, :contact_zipcode,
                       :emergency_name, :emergency_day, :emergency_night,
                       :speak_well, :speak_some,
                       :special_needs,
                       :past_experience,
                       :comments
                      ]

    # Assumes that supplied hash contains ApplyForm and Volunteer
    # attributes, distributes them accordingly and creates/updates
    # underlying models.
    #
    # Typically used from REST interface.
    def self.create_from_hash!(params, user = nil)
      # FIXME - proc je tu potreba dvojity :apply_form?
      hash = params[:apply_form][:apply_form]

      volunteer, volunteer_creation_code = Volunteer.create_or_update(filter(hash, VOLUNTEER_ATTRS))
      apply_form = ApplyForm.new(filter(hash, FORM_ATTRS))
      apply_form.volunteer = volunteer
      workcamps = Outgoing::Workcamp.find(hash["workcamps_ids"]).sort! do |w1,w2|
        hash["workcamps_ids"].index(w1.id) <=> hash["workcamps_ids"].index(w2.id)
      end


      raise InvalidModelError.new(apply_form) unless apply_form.valid?
      raise InvalidModelError.new(volunteer) unless volunteer.valid?
      raise NoWorkcampError and return if workcamps.empty?

      volunteer.save!
      apply_form.save!

      workcamps.each_with_index do |wc,i|
        Outgoing::WorkcampAssignment.new(:order => (i+1), :workcamp => wc, :apply_form => apply_form).save!
      end

      if volunteer_creation_code == :created_but_uncertain
        apply_form.tag_list.add(POSSIBLE_DUPLICATE)
        apply_form.save!
      end

      begin
        # TODO - uzivatele vzit z konfigurace
        mail = ApplyFormMail.new(:action => :submitted,
                                 :form => apply_form,
                                 :user => User.find_by_login('admin'))
        mail.deliver
      rescue
        apply_form.tag_list.add(MAIL_FAILED_TAG)
        apply_form.save!
      end

      apply_form
    end

    private


    def self.filter(hash, attrs)
      filtered = {}

      hash.each do |key,value|
        filtered[key] = value if attrs.include?(key.intern)
      end

      filtered
    end

    # called by observer
    def self.update_cache_for(id)
      stmt = "select current_workcamp_id, current_assignment_id from apply_forms_view where id=#{id}"
      result = connection.select_rows(stmt)[0]
      a = ApplyForm.find(id)
      a.current_workcamp_id_cached = result[0]
      a.current_assignment_id_cached = result[1]
      a.save
    end

  end
end
