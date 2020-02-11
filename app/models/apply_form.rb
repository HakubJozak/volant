require 'rexml/document'

class ApplyForm < ActiveRecord::Base
  validates_lengths_from_database

  include ::Alerts
  include Stars::Model
  include PersonalMethods
  include ApplyForm::WebApi

  acts_as_taggable
  include TaggableExtension
  include FreePlacesUpdater
  after_save :update_free_places
  after_destroy :update_free_places
  before_create :generate_unique_slug

  create_date_time_accessors

  belongs_to :country
  belongs_to :organization
  belongs_to :current_workcamp, foreign_key: 'current_workcamp_id_cached', class_name: 'Workcamp'
  belongs_to :current_assignment, foreign_key: 'current_assignment_id_cached', class_name: 'Outgoing::WorkcampAssignment'
  has_many :workcamps, -> { order 'workcamp_assignments."position" ASC' }, through: :workcamp_assignments, class_name: 'Workcamp', validate: false
  has_many :workcamp_assignments, -> { order '"position" ASC' }, dependent: :delete_all, class_name: 'Outgoing::WorkcampAssignment', validate: false

  scope :query, lambda { |query|
    columns = [ :firstname, :lastname, :email, :birthnumber,
                :phone, :passport_number, :general_remarks].map { |attr|
      "#{table_name}.#{attr}"
    }

    fuzzy_like(*[query,columns].flatten)
  }

  scope :year, lambda { |year|
    year = year.to_i
    where "(#{ApplyForm.table_name}.created_at >= ? AND #{ApplyForm.table_name}.created_at < ?)", Date.new(year,1,1), Date.new(year + 1,1,1)    }

  delegate :asked, :accepted, :rejected, :rejected?, :infosheeted, :confirmed, to: :current_assignment, allow_nil: true

  has_one :payment, dependent: :nullify # , select: 'id, apply_form_id, amount, returned_amount, received, returned_date, return_reason'
  has_many :messages, dependent: :nullify, validate: false
  belongs_to :volunteer, class_name: 'Volunteer'

  accepts_nested_attributes_for :payment

  scope :cancelled, lambda {
    where('cancelled IS NOT NULL')
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
    wa = workcamp_assignments.create!(apply_form: self, workcamp: wc)
    self.reload
    wa
  end

  alias :add_workcamp :assign_workcamp

  def self.preset_order(name,direction)
    table = ApplyForm.table_name
    wc_table = Workcamp.table_name
    # org_table = Organization.table_name

    case name
    when 'createdAt'
      order("#{table}.created_at #{direction}")
    when 'from'
      joins(:current_workcamp).order("#{wc_table}.begin #{direction}")
    when 'to'
      joins(:current_workcamp).order("#{wc_table}.end #{direction}")
    else
      order("#{table}.lastname #{direction},#{table}.firstname #{direction}")
    end
  end

  def add_workcamps_by_ids(workcamp_ids)
    workcamp_ids.each_with_index do |id,i|
      add_workcamp(Workcamp.find(id))

      # HACK over 9000 (but tested)
      # When there is only one workcamp to assign, it is
      # immediately accepted too
      if workcamp_ids.size == 1 && is_a?(Incoming::ApplyForm)
        accept
      end
    end
  end


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
  def self.state_filter(state,account)
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
      filter_params << account.organization_response_limit.days.ago
      filter_params << account.infosheet_waiting_limit.days.from_now
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

  def accepted?
    self.accepted and self.cancelled.nil?
  end

  def paid?
    (self.fee == 0) || (payment.try(:amount) == self.fee)
  end

  def is?(state)
    self.state.name == state
  end

  [ "reject", "accept","ask","infosheet","confirm" ].each do |action|
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

  # TODO: transport postgres view logic into ruby
  def self.update_cache_for(id)
    stmt = "select current_workcamp_id, current_assignment_id from apply_forms_view where id=#{id}"
    result = connection.select_rows(stmt)[0]
    ApplyForm.where(id: id).update_all(current_workcamp_id_cached: result[0], current_assignment_id_cached: result[1])
  end

  def generate_unique_slug
    self.slug = loop do
      random_hash = SecureRandom.urlsafe_base64(nil, false)
      break random_hash unless ApplyForm.exists?(slug: random_hash)
    end
  end

end

# == Schema Information
#
# Table name: apply_forms
#
#  id                           :integer          not null, primary key
#  volunteer_id                 :integer
#  fee                          :decimal(10, 2)   default(2200.0), not null
#  cancelled                    :datetime
#  general_remarks              :text
#  motivation                   :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  current_workcamp_id_cached   :integer
#  current_assignment_id_cached :integer
#  type                         :string(255)      default("Outgoing::ApplyForm"), not null
#  confirmed                    :datetime
#  organization_id              :integer
#  country_id                   :integer
#  firstname                    :string(255)
#  lastname                     :string(255)
#  gender                       :string(255)
#  email                        :string(255)
#  phone                        :string(255)
#  birthnumber                  :string(255)
#  occupation                   :string(255)
#  account                      :string(255)
#  emergency_name               :string(255)
#  emergency_day                :string(255)
#  emergency_night              :string(255)
#  speak_well                   :string(255)
#  speak_some                   :string(255)
#  fax                          :string(255)
#  street                       :string(255)
#  city                         :string(255)
#  zipcode                      :string(255)
#  contact_street               :string(255)
#  contact_city                 :string(255)
#  contact_zipcode              :string(255)
#  birthplace                   :string(255)
#  nationality                  :string(255)
#  special_needs                :text
#  past_experience              :text
#  comments                     :text
#  note                         :text
#  birthdate                    :date
#  passport_number              :string(255)
#  passport_issued_at           :date
#  passport_expires_at          :date
#  slug                         :string
#
