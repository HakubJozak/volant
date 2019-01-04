class Account < ActiveRecord::Base
  include CountryFreeCounters::Account

  belongs_to :organization
  validates :season_end, presence: true
  validates :infosheet_waiting_limit,
            :organization_response_limit,
            numericality: true

  # TODO: will be bound to a domain when multi-tenant
  def self.current
    Account.first
  end

  def to_label
    "Account Settings"
  end
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
