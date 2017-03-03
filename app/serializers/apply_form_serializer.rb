class ApplyFormSerializer < PersonSerializer
  attributes :id, :starred, :fee, :general_remarks,
             :motivation, :confirmed, :cancelled, :created_at, :updated_at,
             :state, :type,
             :no_response_alert, :missing_infosheet_alert

  has_many :workcamp_assignments, embed: :ids, include: false
  has_many :workcamps, embed: :ids, include: false

  has_one :organization, embed: :ids, include: true
  has_one :country, embed: :ids, include: true
  has_one :volunteer, embed: :ids, include: true
  has_one :payment, embed: :ids, include: true
  has_many :tags, embed: :ids, include: true, serializer: TagSerializer

  has_one :current_workcamp, embed: :ids, include: true, root: 'workcamps'
  has_one :current_assignment, embed: :ids, include: true, root: 'workcamp_assignments'
  has_one :current_message, embed: :ids, include: false, root: 'messages'

  def type
    case object
    when Ltv::ApplyForm
      'ltv'
    when Incoming::ApplyForm
      'incoming'
    else
      'outgoing'
    end
  end

  def no_response_alert
    object.waits_too_long?(current_account)
  end

  def missing_infosheet_alert
    object.no_infosheet?(current_account)
  end

  def current_message
    object.current_message
  end

  def state
    s = object.state
    { name: s.name,
      info: s.info,
      actions: s.actions }
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
#
