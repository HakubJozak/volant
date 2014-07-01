class EmailContact < ActiveRecord::Base
  enforce_schema_rules
  validates_presence_of :address
  belongs_to :organization
end
