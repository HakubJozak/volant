class WorkcampSerializer < ActiveModel::Serializer
  has_one :organization, embed: :ids, include: true
  has_one :country, embed: :ids, include: true

  PUBLIC_ATTRS = [ :id,
             :name,
             :code,
             :language,
             :begin,
             :end,
             :capacity,
             :minimal_age,
             :maximal_age,
             :area,
             :accomodation,
             :workdesc,
             :notes,
             :description,
             :extra_fee,
             :extra_fee_currency,
             :region,
             :capacity_natives,
             :capacity_teenagers,
             :capacity_males,
             :capacity_females,
             :airport,
             :train,
             :publish_mode,
             :places, :places_for_males, :places_for_females,
             :accepted_places, :accepted_places_males, :accepted_places_females,
             :asked_for_places, :asked_for_places_males, :asked_for_places_females,
             :longitude, :latitude,
             :requirements ]

  attrs = [ PUBLIC_ATTRS, :free_places, :free_places_for_males, :free_places_for_females, :state ].flatten

  attributes *attrs
end
