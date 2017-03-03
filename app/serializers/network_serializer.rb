class NetworkSerializer < ApplicationSerializer
  attributes :id,:name,:web
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
