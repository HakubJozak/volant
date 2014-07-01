class Partnership < ActiveRecord::Base


  belongs_to :organization
  belongs_to :network

  def to_label
    network.name
  end
end
