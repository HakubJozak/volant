class EmailContact < ActiveRecord::Base
  enforce_schema_rules
  belongs_to :organization
end
