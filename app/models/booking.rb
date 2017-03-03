class Booking < ActiveRecord::Base
  belongs_to :workcamp
  belongs_to :organization
  belongs_to :country

  include FreePlacesUpdater
  after_save :update_free_places
  after_destroy :update_free_places

  validates_presence_of :workcamp, :country

  def male?
    gender == Person::MALE
  end

  def female?
    gender == Person::FEMALE
  end

  def expired?
    expires_at && expires_at < Time.now
  end

end

# == Schema Information
#
# Table name: bookings
#
#  id              :integer          not null, primary key
#  workcamp_id     :integer
#  organization_id :integer
#  country_id      :integer
#  gender          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  expires_at      :date
#
