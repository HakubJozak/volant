# == Schema Information
#
# Table name: countries
#
#  id          :integer          not null, primary key
#  code        :string(2)        not null
#  name_cz     :string(255)
#  name_en     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  triple_code :string(3)
#

class Country < ActiveRecord::Base
  enforce_schema_rules

  def name
    send("name_#{I18n.locale}") || "Unknown name (#{code})"
  end

  alias :to_label :name
  alias :to_s :name

end
