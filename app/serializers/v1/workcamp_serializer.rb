class V1::WorkcampSerializer < ActiveModel::Serializer
  has_one :organization, serializer: V1::OrganizationSerializer
  has_one :country, serializer: V1::CountrySerializer

  attributes :id, :name, :code, :language, :begin, :end, :capacity, :minimal_age, :maximal_age,
      :area, :accomodation, :workdesc, :notes, :description, :extra_fee, :extra_fee_currency,
      :region, :capacity_natives, :capacity_teenagers, :capacity_males, :capacity_females,
      :airport, :train, :publish_mode,
      :places, :places_for_males, :places_for_females,
      :free_places, :free_places_for_males, :free_places_for_females,
      :duration,
      :longitude, :latitude, :requirements,
      :workcamp_intentions

  def workcamp_intentions
    object.intentions.map(&:code)
  end
end
