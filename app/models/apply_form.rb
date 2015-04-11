require 'rexml/document'

class ApplyForm < ActiveRecord::Base
  include ::Alerts
  include Stars::Model
  include PersonalMethods
  include ApplyForm::WebApi

  acts_as_taggable
  include TaggableExtension
  include Export::Excel::ApplyForm
  include FreePlacesUpdater
  after_save :update_free_places
  after_destroy :update_free_places

  create_date_time_accessors

  belongs_to :country
  belongs_to :organization
  belongs_to :current_workcamp, foreign_key: 'current_workcamp_id_cached', class_name: 'Workcamp'
  belongs_to :current_assignment, foreign_key: 'current_assignment_id_cached', class_name: 'Outgoing::WorkcampAssignment'
  has_many :workcamps, -> { order 'workcamp_assignments."order" ASC' }, through: :workcamp_assignments, class_name: 'Workcamp', validate: false
  has_many :workcamp_assignments, -> { order '"order" ASC' }, dependent: :delete_all, class_name: 'Outgoing::WorkcampAssignment', validate: false

  scope :year, lambda { |year|
    year = year.to_i
    where "(#{ApplyForm.table_name}.created_at >= ? AND #{ApplyForm.table_name}.created_at < ?)", Date.new(year,1,1), Date.new(year + 1,1,1)    }

  delegate :asked, :accepted, :rejected, :rejected?, :infosheeted, to: :current_assignment, allow_nil: true

  has_one :payment, dependent: :nullify # , select: 'id, apply_form_id, amount, returned_amount, received, returned_date, return_reason'
  has_many :messages, dependent: :nullify, validate: false
  belongs_to :volunteer, class_name: 'Volunteer'

  accepts_nested_attributes_for :payment

  scope :query, lambda { |query|
    like = "%#{query}%"
    str = """
            #{ApplyForm.table_name}.firstname ILIKE ? or
            #{ApplyForm.table_name}.lastname ILIKE  ? or
            #{ApplyForm.table_name}.birthnumber ILIKE ? or
            #{ApplyForm.table_name}.email ILIKE ? or
            #{ApplyForm.table_name}.general_remarks ILIKE ?
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
    where('date(apply_forms.created_at) > ?',day - 1)
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

    wa = workcamp_assignments.create!(apply_form: self, workcamp: wc, order: order)
    self.reload
    wa
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

  # TODO: replace by state column on the ApplyForm
  def self.state_filter(state)
    wa = Outgoing::WorkcampAssignment.table_name
    wc = Workcamp.table_name
    filter_sql = ''
    filter_params = []

    case state
    when "alerts"
      filter_sql << '('
      filter_sql << " ((#{wa}.asked <= ?) AND #{wa}.accepted IS NULL AND #{wa}.rejected IS NULL and cancelled IS NULL)"
      filter_sql << ' OR '
      filter_sql << " (cancelled IS NULL AND #{wa}.accepted IS NOT NULL AND #{wa}.infosheeted IS NULL AND #{wc}.\"begin\" <= ?)"
      filter_sql << ')'
      filter_params << InexRules.organization_response_limit
      filter_params << InexRules.infosheet_waiting_limit
      joins(:current_workcamp).joins(:current_assignment).where(*[ filter_sql ].concat(filter_params))

    when "cancelled"
      where('cancelled IS NOT NULL')

    when "asked"
      filter_sql << " #{wa}.asked IS NOT NULL AND #{wa}.accepted IS NULL AND #{wa}.rejected IS NULL and cancelled IS NULL"
      joins(:current_workcamp).joins(:current_assignment).where(*[ filter_sql ].concat(filter_params))

    when "accepted"
      filter_sql << " cancelled IS NULL AND #{wa}.accepted IS NOT NULL"
      joins(:current_workcamp).joins(:current_assignment).where(*[ filter_sql ].concat(filter_params))

    when "infosheeted"
      filter_sql << " cancelled IS NULL AND #{wa}.infosheeted IS NOT NULL"
      joins(:current_workcamp).joins(:current_assignment).where(*[ filter_sql ].concat(filter_params))

    when "rejected"
      filter_sql << " cancelled IS NULL AND #{wa}.rejected IS NOT NULL"
      joins(:current_workcamp).joins(:current_assignment).where(*[ filter_sql ].concat(filter_params))

    when "pending"
      filter_sql << " payments.id IS NOT NULL AND #{wa}.asked IS NULL AND #{wa}.accepted IS NULL and #{wa}.rejected IS NULL AND cancelled IS NULL"
      joins(:current_workcamp).joins(:current_assignment).where(*[ filter_sql ].concat(filter_params))

    when "without_payment"
      where('payments.id is NULL')
    else
      where('TRUE')
    end
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
    (self.fee == 0) || (payment.try(:amount) == self.fee)
  end

  def is?(state)
    self.state.name == state
  end

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

  def cancel
    self.cancelled = Time.now
    save(validate: false)
    self
  end

  def starred?(user)
    starrings.where(user: user).count > 0
  end

  def cancelled?
    not cancelled.nil?
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
    ApplyForm.where(id: id).update_all(current_workcamp_id_cached: result[0], current_assignment_id_cached: result[1])
  end

end
