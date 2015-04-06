class WorkcampSerializer < ApplicationSerializer
  has_one :organization, embed: :ids, include: true, serializer: OrganizationSerializer
  has_one :country, embed: :ids, include: true
  has_many :tags, embed: :ids, include: true, serializer: TagSerializer
  has_many :workcamp_intentions, embed: :ids, include: true, serializer: WorkcampIntentionSerializer
  has_many :workcamp_assignments, embed: :ids, include: false
  has_many :import_changes, embed: :ids, include: true

  attributes :apply_form_ids

  attributes :id, :state, :duration, :type,
      :starred, :name, :code, :language, :begin, :end, :minimal_age, :maximal_age,
      :area, :accomodation, :workdesc, :notes, :description, :extra_fee, :extra_fee_currency,
      :region,
      :airport, :train, :publish_mode,:places, :places_for_males, :places_for_females,
      :longitude, :latitude, :requirements,
      :organization_id, :country_id, :created_at, :updated_at,
      # Placement
      :accepted_places, :accepted_places_males, :accepted_places_females,
      :asked_for_places, :asked_for_places_males, :asked_for_places_females,
      :free_places, :free_places_for_males, :free_places_for_females,
      :capacity, :capacity_natives, :capacity_teenagers, :capacity_males, :capacity_females,
      :free_capacity, :free_capacity_males, :free_capacity_females



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
