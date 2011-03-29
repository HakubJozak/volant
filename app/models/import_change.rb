class ImportChange < ActiveRecord::Base
  enforce_schema_rules
  belongs_to :workcamp

  def apply(wc = self.workcamp)
    wc.send("#{self.field}=", self.value)
  end

  module Maker

    IGNORED_ATTR = [ :created_at, :updated_at, :state ].freeze

    def create_by_diff(wc)
      proxy_owner.diff(wc).each do |field, value|
        unless IGNORED_ATTR.include?(field)
          self.build :field => field.to_s, :value => value
        end
      end

      self
    end
  end
end
