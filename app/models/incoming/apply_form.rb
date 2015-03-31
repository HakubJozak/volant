module Incoming
  class ApplyForm < ::ApplyForm
    belongs_to :country
    belongs_to :organization
    belongs_to :participant, foreign_key: 'volunteer_id'

    validates :country, :organization, presence: true
    
    alias :sending_organization :organization
    
    def confirmed?
      !self.confirmed.nil?
    end

    def confirm
      self.confirmed = Time.zone.now
    end
  end
end
