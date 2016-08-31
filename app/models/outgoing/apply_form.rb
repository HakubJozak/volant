module Outgoing
  class ApplyForm < ::ApplyForm
    # validates :fee, presence: true
    validates :motivation, presence: true, if: :strict_validation?
  end
end
