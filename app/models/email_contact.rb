class EmailContact < ActiveRecord::Base

  validates_presence_of :address
  belongs_to :organization
end
