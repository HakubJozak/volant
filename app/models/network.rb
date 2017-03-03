class Network < ActiveRecord::Base
  has_many :partnerships, dependent: :delete_all
  has_many :organizations, :through => :partnerships, validate: false
  validates :name, presence: true

  def to_s
    name
  end
end

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
