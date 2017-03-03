class Partnership < ActiveRecord::Base


  belongs_to :organization
  belongs_to :network

  def to_label
    network.name
  end
end

# == Schema Information
#
# Table name: partnerships
#
#  id              :integer          not null, primary key
#  description     :string(255)
#  network_id      :integer
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#
