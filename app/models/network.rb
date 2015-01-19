class Network < ActiveRecord::Base
  has_many :partnerships, dependent: :delete_all
  has_many :organizations, :through => :partnerships

  def to_s
    name
  end
end
