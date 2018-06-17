module PhoneValidation
  FORMAT = /\A\+?[0-9 \-\/]{6,20}\z/
  MESSAGE = 'should be formatted like +420 123 456 789'

  extend ActiveSupport::Concern

  included do
    validates :phone,:emergency_day, :emergency_email, format: { with: FORMAT, message: MESSAGE }, if: :strict_validation?
  end

end
