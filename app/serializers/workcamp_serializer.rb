class WorkcampSerializer < ApplicationSerializer
  has_one :organization, embed: :ids, include: true, serializer: OrganizationSerializer
  has_one :country, embed: :ids, include: true
  has_many :tags, embed: :ids, include: true, serializer: TagSerializer
  has_many :workcamp_intentions, embed: :ids, include: true, serializer: WorkcampIntentionSerializer
  has_many :workcamp_assignments, embed: :ids, include: false
  has_many :import_changes, embed: :ids, include: true
  has_many :bookings, embed: :ids, include: true

  attributes :apply_form_ids

  attributes :id, :state, :duration, :type,
      :starred, :name, :code, :language, :begin, :end, :minimal_age, :maximal_age,
      :variable_dates,
      :area, :accommodation, :workdesc, :notes, :description,
      :price, :extra_fee, :extra_fee_currency,
      :project_summary,
      :partner_organization,
      :region,
      :airport, :train, :publish_mode,:places, :places_for_males, :places_for_females,
      :longitude, :latitude, :requirements,
      :organization_id, :country_id, :created_at, :updated_at,
      # Placement
      :accepted_places, :accepted_places_males, :accepted_places_females,
      :asked_for_places, :asked_for_places_males, :asked_for_places_females,
      :free_places, :free_places_for_males, :free_places_for_females,
      :capacity, :capacity_natives, :capacity_teenagers, :capacity_males, :capacity_females,
      :free_capacity, :free_capacity_males, :free_capacity_females,
      :all_organizations_emails, :all_applications_emails



  def type
    case object
    when Ltv::Workcamp
      'ltv'
    when Incoming::Workcamp
      'incoming'
    else
      'outgoing'
    end
  end

  def apply_form_ids
    object.workcamp_assignments.map { |wa| wa.apply_form_id }
  end

  def workcamp_assignments
    object.workcamp_assignments
  end

  def workcamp_intentions
    object.intentions
  end
end

# == Schema Information
#
# Table name: workcamps
#
#  id                       :integer          not null, primary key
#  code                     :string(255)      not null
#  name                     :string(255)      not null
#  country_id               :integer          not null
#  organization_id          :integer          not null
#  language                 :string(255)
#  begin                    :date
#  end                      :date
#  capacity                 :integer
#  places                   :integer          not null
#  places_for_males         :integer          not null
#  places_for_females       :integer          not null
#  minimal_age              :integer          default(18)
#  maximal_age              :integer          default(99)
#  area                     :text
#  accommodation            :text
#  workdesc                 :text
#  notes                    :text
#  description              :text
#  created_at               :datetime
#  updated_at               :datetime
#  extra_fee                :decimal(10, 2)
#  extra_fee_currency       :string(255)
#  region                   :string(65536)
#  capacity_natives         :integer
#  capacity_teenagers       :integer
#  capacity_males           :integer
#  capacity_females         :integer
#  airport                  :string(255)
#  train                    :string(4096)
#  publish_mode             :string(255)      default("ALWAYS"), not null
#  accepted_places          :integer          default(0), not null
#  accepted_places_males    :integer          default(0), not null
#  accepted_places_females  :integer          default(0), not null
#  asked_for_places         :integer          default(0), not null
#  asked_for_places_males   :integer          default(0), not null
#  asked_for_places_females :integer          default(0), not null
#  type                     :string(255)      default("Outgoing::Workcamp"), not null
#  longitude                :decimal(11, 7)
#  latitude                 :decimal(11, 7)
#  state                    :string(255)
#  requirements             :text
#  free_places              :integer          default(0), not null
#  free_places_for_males    :integer          default(0), not null
#  free_places_for_females  :integer          default(0), not null
#  project_id               :string(255)
#  duration                 :integer
#  free_capacity_males      :integer          default(0), not null
#  free_capacity_females    :integer          default(0), not null
#  free_capacity            :integer          default(0), not null
#  partner_organization     :string(4096)
#  project_summary          :string(4096)
#
