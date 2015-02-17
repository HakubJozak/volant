class Account < ActiveRecord::Base
  belongs_to :organization

  def season_end
    season_start
  end
  
  # TODO: will be bound to a domain when multi-tenant
  def self.current
    Account.first
  end
end
