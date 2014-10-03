class EmailContact < ActiveRecord::Base
  validates_presence_of :address, :organization_id
  belongs_to :organization
end
