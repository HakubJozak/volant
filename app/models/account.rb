class Account < ActiveRecord::Base
  belongs_to :organization
  validates :season_end, presence: true

  # TODO: will be bound to a domain when multi-tenant
  def self.current
    Account.first
  end
end
