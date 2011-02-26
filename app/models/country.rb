class Country < ActiveRecord::Base
  enforce_schema_rules

  # Finds all countries that has some organization.
  def self.find_those_with_orgs
    Country.find_by_sql(%{
       SELECT DISTINCT countries.* FROM countries
        INNER JOIN organizations ON countries.id = organizations.country_id
        ORDER BY countries.name_#{I18n.locale}
    })
  end

  def name
    send("name_#{I18n.locale}") || "Unknown name (#{code})"
  end

  alias :to_label :name
  alias :to_s :name

end
