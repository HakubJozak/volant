module PhoneValidation
  FORMAT = /\A\+?[0-9 \-\/]{6,20}\z/
  MESSAGE = 'should be formatted like +420 123 456 789'

  extend ActiveSupport::Concern

  included do
    validates :phone,:emergency_day, :emergency_night, format: { with: FORMAT, message: MESSAGE }, if: :validate_phones?
  end

  def validate_phones?
    @validate_phones
  end
  
  def validate_phones!
    @validate_phones = true
  end
end
