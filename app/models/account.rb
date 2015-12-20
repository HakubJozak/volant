class Account < ActiveRecord::Base
  belongs_to :organization
  validates :season_end, presence: true
  validates :infosheet_waiting_limit,
            :organization_response_limit,
            numericality: true

  # TODO: will be bound to a domain when multi-tenant
  def self.current
    Account.first
  end
end
