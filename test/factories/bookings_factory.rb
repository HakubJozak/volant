Factory.define :booking, :class => Incoming::Booking do |b|
  b.association :country
  b.association :organization
  b.workcamp { |wc| wc.association(:incoming_workcamp) }
  b.gender 'm'
end
