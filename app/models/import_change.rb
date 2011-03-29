class ImportChange < ActiveRecord::Base
  enforce_schema_rules
  belongs_to :workcamp

  def apply(wc = self.workcamp)
    wc.send("#{self.field}=", self.value)
  end

  module Maker
    def create_by_diff(wc)
      puts proxy_owner.diff(wc).inspect
    end
  end
end
