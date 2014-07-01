class Network < ActiveRecord::Base
  enforce_schema_rules

  acts_as_commentable
  has_many :partnerships
  has_many :organizations, :through => :partnerships

  def to_s
    name
  end
end
