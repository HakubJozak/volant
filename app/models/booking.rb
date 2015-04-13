class Booking < ActiveRecord::Base
  belongs_to :workcamp
  belongs_to :organization
  belongs_to :country
end
