class CountrySerializer < ApplicationSerializer
  has_one :country_zone, embed: :ids, include: true
  attributes :name_en, :name_cz, :code, :triple_code, :region, :id
end

# == Schema Information
#
# Table name: countries
#
#  id                   :integer          not null, primary key
#  code                 :string(2)        not null
#  name_cz              :string(255)
#  name_en              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  triple_code          :string(3)
#  region               :string(255)      default("1"), not null
#  country_zone_id      :integer
#  free_workcamps_count :integer          default(0)
#  free_ltvs_count      :integer          default(0)
#
