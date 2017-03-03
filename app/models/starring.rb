class Starring < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite, polymorphic: true
end

# == Schema Information
#
# Table name: starrings
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  favorite_id   :integer          not null
#  favorite_type :string(255)      not null
#  created_at    :datetime
#  updated_at    :datetime
#
