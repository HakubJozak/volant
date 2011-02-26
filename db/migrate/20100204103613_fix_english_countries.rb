class FixEnglishCountries < ActiveRecord::Migration
  def self.up
    Country.find_by_code('IM').update_attribute(:name_en,'Island of Man')
    Country.find_by_code('BL').update_attribute(:name_en,'Saint-Barthélemy')
    Country.find_by_code('RS').update_attribute(:name_en,'Srbsko')
    Country.find_by_code('TL').update_attribute(:name_en,'Eastern Timor')
    Country.find_by_code('GG').update_attribute(:name_en,'Guernsey')
    Country.find_by_code('JE').update_attribute(:name_en,'Jersey')
    Country.find_by_code('ME').update_attribute(:name_en,'Monte Negro')
    Country.find_by_code('MF').update_attribute(:name_en,'Saint-Martin')
    Country.find_by_code('AX').update_attribute(:name_en,'Ålandy')
  end

  def self.down
  end
end
