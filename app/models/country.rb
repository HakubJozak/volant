class Country < ActiveRecord::Base
  include CountryFreeCounters::Country

  belongs_to :country_zone

  validates :name_en, presence: true
  validates :code, format: { with: /[A-Z]{2}/, message: 'the format is XX' }
  validates :triple_code, format: { with: /[A-Z]{3}/, message: 'the format is XXX' }

  has_many :workcamps, -> {
    where("type in (?)", ['Outgoing::Workcamp','Incoming::Workcamp'])
  }, validate: false

  has_many :ltv_projects, class_name: 'Ltv::Workcamp', validate: false

  def name
    self.name_en
  end

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
