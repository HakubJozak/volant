class Country < ActiveRecord::Base

  belongs_to :country_zone

  validates :name_en, presence: true
  validates :code, format: { with: /[A-Z]{2}/, message: 'the format is XX' }
  validates :triple_code, format: { with: /[A-Z]{3}/, message: 'the format is XXX' }

  def name
    self.name_en
  end

end
