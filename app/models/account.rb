class Account < ActiveRecord::Base
  belongs_to :organization

  # TODO: will be bound to a domain when multi-tenant
  def self.current
    Account.first
  end
end
