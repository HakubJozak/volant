Factory.define :booking, :class => Incoming::Booking do |b|
  b.association :country
  b.association :organization
  b.workcamp { |wc| wc.association(:incoming_workcamp) }
end

Factory.define :male_booking, parent: :booking do |b|
  b.gender 'm'
end

Factory.define :female_booking, parent: :booking do |b|
  b.gender 'f'
end
