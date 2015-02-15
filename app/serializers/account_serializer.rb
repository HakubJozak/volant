class AccountSerializer < ActiveModel::Serializer
  attributes :id, :season_start, :ask_response_limit, :infosheet_waiting_limit
end
