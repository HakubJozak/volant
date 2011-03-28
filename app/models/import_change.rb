class ImportChange < ActiveRecord::Base
  enforce_schema_rules

  belongs_to :workcamp
end
