class ActiveRecord::Base
  def self.unaccented_like(attr)
    "unaccent(#{attr}) ILIKE unaccent(?)" 
  end
end
