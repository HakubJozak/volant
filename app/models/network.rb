class Network < ActiveRecord::Base
  has_many :partnerships, dependent: :delete_all
  has_many :organizations, :through => :partnerships
  validates :name, presence: true
  
  def to_s
    name
  end
end
