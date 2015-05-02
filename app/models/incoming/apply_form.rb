module Incoming
  class ApplyForm < ::ApplyForm
    belongs_to :participant, foreign_key: 'volunteer_id'

    validates :country, :organization, presence: true

    alias :sending_organization :organization

  end
end
