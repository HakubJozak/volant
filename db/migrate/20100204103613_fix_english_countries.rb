class FixEnglishCountries < ActiveRecord::Migration
  def self.up
    Country.find_by_code('IM').to_a.any? {|c| c.update_attribute(:name_en,'Island of Man') }
    Country.find_by_code('BL').to_a.any? {|c| c.update_attribute(:name_en,'Saint-Barthélemy') }
    Country.find_by_code('RS').to_a.any? {|c| c.update_attribute(:name_en,'Srbsko') }
    Country.find_by_code('TL').to_a.any? {|c| c.update_attribute(:name_en,'Eastern Timor') }
    Country.find_by_code('GG').to_a.any? {|c| c.update_attribute(:name_en,'Guernsey') }
    Country.find_by_code('JE').to_a.any? {|c| c.update_attribute(:name_en,'Jersey') }
    Country.find_by_code('ME').to_a.any? {|c| c.update_attribute(:name_en,'Monte Negro') }
    Country.find_by_code('MF').to_a.any? {|c| c.update_attribute(:name_en,'Saint-Martin') }
    Country.find_by_code('AX').to_a.any? {|c| c.update_attribute(:name_en,'Ålandy') }
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
