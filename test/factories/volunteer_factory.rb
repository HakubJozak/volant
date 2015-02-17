Factory.define :person do |f|
  f.firstname "Jakub"
  f.lastname "Hozak"
  f.email "jakub.hozak@gmail.com"
  f.gender "m"
  f.phone "+420 777 855 359"
  f.birthnumber "8203270438"
  f.nationality "Czech"
  f.occupation "Programator"
  f.city "Praha"
  f.zipcode '10100'
  f.street 'Somewhere 22'
  f.birthdate 20.years.ago
  f.past_experience 'Rich'
  f.emergency_day '23239'
  f.emergency_name 'Tony'  
end

Factory.define :volunteer, :class => Volunteer, :parent => :person do |f|
end

Factory.define :male, :parent => :volunteer do |m|
  m.gender 'm'
end

Factory.define :female, :parent => :volunteer do |f|
  f.gender 'f'
end

Factory.define :leader, :class => Incoming::Leader, :parent => :volunteer do |l|
end

Factory.define :participant, :class => Incoming::Participant, :parent => :person do |p|
  p.association :country
  p.association :organization
  p.apply_form { Incoming::ApplyForm.create(motivation: 'stuff') }
end
