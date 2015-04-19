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
    self.expires_at < Time.now
  end

end
