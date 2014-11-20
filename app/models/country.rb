class Country < ActiveRecord::Base

  validates :name_en, presence: true
  validates :code, format: { with: /[A-Z]{2}/, message: 'the format is XX' }
  validates :triple_code, format: { with: /[A-Z]{3}/, message: 'the format is XXX' }


end
