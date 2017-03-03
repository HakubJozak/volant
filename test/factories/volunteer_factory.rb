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
  f.emergency_day "+420 777 855 359"
  f.emergency_night "+420 777 855 359"  
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
end

# == Schema Information
#
# Table name: people
#
#  id                  :integer          not null, primary key
#  firstname           :string(255)      not null
#  lastname            :string(255)      not null
#  gender              :string(255)      not null
#  old_schema_key      :integer
#  email               :string(255)
#  phone               :string(255)
#  birthdate           :date
#  birthnumber         :string(255)
#  nationality         :string(255)
#  occupation          :string(255)
#  account             :string(255)
#  emergency_name      :string(255)
#  emergency_day       :string(255)
#  emergency_night     :string(255)
#  speak_well          :string(255)
#  speak_some          :string(255)
#  special_needs       :text
#  past_experience     :text
#  comments            :text
#  created_at          :datetime
#  updated_at          :datetime
#  fax                 :string(255)
#  street              :string(255)
#  city                :string(255)
#  zipcode             :string(255)
#  contact_street      :string(255)
#  contact_city        :string(255)
#  contact_zipcode     :string(255)
#  birthplace          :string(255)
#  type                :string(255)      default("Volunteer"), not null
#  workcamp_id         :integer
#  country_id          :integer
#  note                :text
#  organization_id     :integer
#  passport_number     :string(255)
#  passport_issued_at  :date
#  passport_expires_at :date
#
