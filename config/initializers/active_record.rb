class ActiveRecord::Base
  def self.fuzzy_like(*attributes)
    query = attributes.shift

    if query.present?
      conditions = attributes.map { |attr|  unaccented_like(attr) }
      values = attributes.map { like_string(query) }
      where [ conditions.join(' or '), values ].flatten
    end
  end

  def self.unaccented_like(attr)
    "unaccent(#{attr}) ILIKE unaccent(?)" 
  end

  def self.like_string(query)
    "%#{query}%"
  end
end
