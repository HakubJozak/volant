class ImportChange < ActiveRecord::Base
  enforce_schema_rules

  belongs_to :workcamp

  def apply(wc = self.workcamp)
    wc.send("#{self.field}=", self.value)
  end
end
