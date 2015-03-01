class Ltv::ApplyForm < ::Outgoing::ApplyForm
  validates_presence_of :volunteer, :fee
end
