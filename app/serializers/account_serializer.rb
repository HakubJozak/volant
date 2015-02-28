class AccountSerializer < ActiveModel::Serializer
  attributes :id, :season_end, :organization_response_limit,
             :infosheet_waiting_limit
  has_one :organization, embed: :ids, include: true
end
