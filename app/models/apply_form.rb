require 'rexml/document'

class ApplyForm < ActiveRecord::Base
  include ::Alerts
  include Stars::Model

  acts_as_taggable
  include TaggableExtension
  include Export::Excel::ApplyForm
  include FreePlacesUpdater
  after_save :update_free_places
  after_destroy :update_free_places

  create_date_time_accessors

  belongs_to :current_workcamp, foreign_key: 'current_workcamp_id_cached', class_name: 'Workcamp'
  belongs_to :current_assignment, foreign_key: 'current_assignment_id_cached', class_name: 'Outgoing::WorkcampAssignment'
  has_many :workcamps, -> { order 'workcamp_assignments."order" ASC' }, through: :workcamp_assignments, class_name: 'Workcamp', validate: false
  has_many :workcamp_assignments, -> { order '"order" ASC' }, dependent: :delete_all, class_name: 'Outgoing::WorkcampAssignment', validate: false


  # TODO: replace by real DB attributes
  delegate :firstname, :lastname, :gender, :email, :phone, :birthdate, :birthnumber,
           :nationality, :occupation, :account, :emergency_name, :emergency_day,
           :emergency_night, :speak_well, :speak_some, :special_needs, :past_experience, :comments,
           :fax, :street, :city, :zipcode, :contact_street, :contact_city, :contact_zipcode,
           :birthplace, :note, :male?, :female?, to: :volunteer, allow_nil: true

  scope :year, lambda { |year|
    year = year.to_i
    where "(#{ApplyForm.table_name}.created_at >= ? AND #{ApplyForm.table_name}.created_at < ?)", Date.new(year,1,1), Date.new(year + 1,1,1)    }

  delegate :asked, :accepted, :rejected, :rejected?, :infosheeted, to: :current_assignment, allow_nil: true

  has_one :payment, dependent: :nullify # , select: 'id, apply_form_id, amount, returned_amount, received, returned_date, return_reason'
  has_many :messages, dependent: :nullify, validate: false
  belongs_to :volunteer, class_name: 'Volunteer'

  accepts_nested_attributes_for :payment
  accepts_nested_attributes_for :volunteer

  scope :query, lambda { |query|
    like = "%#{query}%"
    str = """
            firstname ILIKE ? or
            lastname ILIKE  ? or
            birthnumber ILIKE ? or
            email ILIKE ? or
            general_remarks ILIKE ?
           """
    joins(:volunteer).where(str,like, like, like,like,like)
  }

  scope :accepted, lambda {
    joins(:current_assignment).where(cancelled: nil).where('workcamp_assignments.accepted IS NOT NULL')
  }

  scope :on_project, lambda { |day = Date.today|
    accepted.joins(:current_workcamp).where("workcamps.begin <= :day AND workcamps.end >= :day",day: day)
  }

  scope :returns_between, lambda { |from,to|
    accepted.joins(:current_workcamp).where("workcamps.end >= ? AND workcamps.end <= ?",from,to)
  }

  scope :leaves_between, lambda { |from,to|
    accepted.joins(:current_workcamp).where("workcamps.begin >= ? AND workcamps.begin <= ?",from,to)
  }

  scope :just_submitted, lambda { |day = Date.today|
    where('date(created_at) = ?',day)
  }


  def current_message
    messages.not_sent.first
  end

  def assign_workcamp(wc)
    # don't do anything if it is already assigned
    return self if workcamp_assignments.any? { |wa| wa.workcamp == wc }

    order = if workcamp_assignments.empty?
              1
            else
              workcamp_assignments.last.order + 1
            end

    workcamp_assignments.create!(apply_form: self, workcamp: wc, order: order)
    self.reload
  end

  alias :add_workcamp :assign_workcamp

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

  def self.create_by_birthnumber(attrs)
    form = nil
    birthnumber = attrs[:volunteer_attributes][:birthnumber]
    volunteer = Volunteer.find_by_birthnumber(birthnumber)

    workcamps = attrs.delete(:workcamp_ids).to_a.map do |id|
      ::Workcamp.find_by_id(id)
      # TODO: handle smarter
      # if self === Outgoing::ApplyForm
      #   Outgoing::Workcamp.find_by_id(id)
      # else
      #   Ltv::Workcamp.find_by_id(id)
      # end
    end.compact


    Volunteer.transaction do
      if volunteer
        form = self.new(attrs)
        form.volunteer = volunteer
        volunteer.assign_attributes(attrs[:volunteer_attributes])
        volunteer.save && form.save
      else
        form = self.new(attrs)
        form.save
      end

      if form.valid? && form.volunteer.valid?
        workcamps.each_with_index do |wc,i|
          form.workcamp_assignments.create!(workcamp: wc, order: i+1)
        end
      end
    end

    form
  end

  # TODO: replace by state column on the ApplyForm
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

    where(*[ filter_sql ].concat(filter_params))
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
  [ "accept","ask","reject","infosheet" ].each do |action|
    define_method(action) do |time = Time.now|
      if self.current_assignment
        current_assignment.send(action,time)
        self.reload
      else
        raise "This apply form has no current assignment, cannot run action #{action}"
      end
    end
  end

  def name
    who = (volunteer)? volunteer.name : '(?)'
    "#{who} (#{I18n.localize(self.created_at.to_date)})"
  end

  def to_label
    name
  end

  def toggle_cancelled
    toggle_date(:cancelled)
  end

  def cancel
    self.cancelled = Time.now
    save!
    self
  end

  def starred?(user)
    starrings.where(user: user).count > 0
  end

  def cancelled?
    not cancelled.nil?
  end

  private

  def toggle_date(attr)
    if send("#{attr}?")
      self.send("#{attr}=", nil)
    else
      self.send("#{attr}=", Time.zone.now)
    end

    save!
    self
  end

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
    ApplyForm.where(id: id).update_all(current_workcamp_id_cached: result[0], current_assignment_id_cached: result[1])
  end

end
