class Booking < ActiveRecord::Base
  belongs_to :workcamp
  belongs_to :organization
  belongs_to :country

  validates_presence_of :workcamp, :country
end
