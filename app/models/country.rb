class Country < ActiveRecord::Base
  include CountryFreeCounters::Country
  
  belongs_to :country_zone

  validates :name_en, presence: true
  validates :code, format: { with: /[A-Z]{2}/, message: 'the format is XX' }
  validates :triple_code, format: { with: /[A-Z]{3}/, message: 'the format is XXX' }

  has_many :workcamps, class_name: 'Outgoing::Workcamp', validate: false
  has_many :ltv_projects, class_name: 'Ltv::Workcamp', validate: false

  def name
    self.name_en
  end

end
