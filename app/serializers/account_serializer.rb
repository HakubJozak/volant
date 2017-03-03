class AccountSerializer < ActiveModel::Serializer
  attributes :id, :season_end, :organization_response_limit,
             :infosheet_waiting_limit
  has_one :organization, embed: :ids, include: true
end

# == Schema Information
#
# Table name: accounts
#
#  id                          :integer          not null, primary key
#  organization_id             :integer          not null
#  season_end                  :date             default(Sun, 15 Mar 2015), not null
#  organization_response_limit :integer          default(4), not null
#  infosheet_waiting_limit     :integer          default(30), not null
#  created_at                  :datetime
#  updated_at                  :datetime
#
