class Starring < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite, polymorphic: true
end
