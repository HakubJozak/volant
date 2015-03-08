class V1::WorkcampSerializer < ActiveModel::Serializer
  has_one :organization, serializer: V1::OrganizationSerializer
  has_one :country, serializer: V1::CountrySerializer
  has_many :workcamp_intentions, serializer: V1::WorkcampIntentionSerializer


  attributes :id, :name, :code, :language, :begin, :end, :capacity, :minimal_age, :maximal_age,
      :area, :accomodation, :workdesc, :notes, :description, :extra_fee, :extra_fee_currency,
      :region, :capacity_natives, :capacity_teenagers, :capacity_males, :capacity_females,
      :airport, :train,
      :places, :places_for_males, :places_for_females,
      :free_places, :free_places_for_males, :free_places_for_females,
      :duration,
      :longitude, :latitude, :requirements,
      :created_at,
      :type, :tags

#  has_many :tags, serializer: V1::TagSerializer, embed: true, include: true

  def type
    case object
    when Ltv::Workcamp then 'ltv'
    when Incoming::Workcamp then 'incoming'
    else 'outgoing'
    end
  end

  def duration
    object.duration || if object.end and object.begin
                         (object.end.to_time - object.begin.to_time).to_i / 1.day + 1
                       else
                         nil
                       end
  end

  def workcamp_intentions
    object.intentions
  end
end
