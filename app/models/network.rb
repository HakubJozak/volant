# == Schema Information
#
# Table name: networks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  web        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Network < ActiveRecord::Base
  enforce_schema_rules

  acts_as_commentable
  has_many :partnerships
  has_many :organizations, :through => :partnerships

  def to_s
    name
  end
end
