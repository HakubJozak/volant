class Network < ActiveRecord::Base



  has_many :partnerships
  has_many :organizations, :through => :partnerships

  def to_s
    name
  end
end
