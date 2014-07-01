class Country < ActiveRecord::Base
  enforce_schema_rules

  def name
    send("name_#{I18n.locale}") || "Unknown name (#{code})"
  end

  alias :to_label :name
  alias :to_s :name

end
