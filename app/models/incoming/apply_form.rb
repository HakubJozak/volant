module Incoming
  class ApplyForm < ::ApplyForm
    belongs_to :country
    belongs_to :organization

    validates :country, :organization, presence: true
    
    alias :sending_organization :organization
    alias :participant :volunteer
    
    def confirmed?
      !self.confirmed.nil?
    end

    def confirm
      self.confirmed = Time.zone.now
    end
  end
end
