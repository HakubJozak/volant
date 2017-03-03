class CountryZone < ActiveRecord::Base
end

# == Schema Information
#
# Table name: country_zones
#
#  id         :integer          not null, primary key
#  name_en    :string(255)
#  name_cz    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  continent  :string(255)
#
