class Account < ActiveRecord::Base
  belongs_to :organization

  # TODO: will be bound to a domain when multi-tenant
  def self.current
    raise 'More than one account present!' if Account.count != 1
    Account.first
  end
end
