require Rails.root.join('app/models/apply_form').to_s

# do not use! it has no assignment
Factory.define :abstract_form, class: ::ApplyForm do |f|
  f.firstname 'John'
  f.lastname 'Doe'
  f.gender 'm'
  f.birthnumber '01234567'
  f.email 'john.doe@example.com'
  f.general_remarks "nothing to say"
  f.motivation "i WANT to go there"
end

Factory.define :apply_form, parent: :abstract_form,class: Outgoing::ApplyForm do |f|
  f.fee 2200
  f.association :volunteer
  f.association :payment
end

Factory.define :incoming_apply_form, parent: :abstract_form,class: Incoming::ApplyForm do |f|
  f.fee 0
  f.association :country
  f.association :organization
end

Factory.define :incoming_male_form, parent: :incoming_apply_form do |f|
  f.gender Person::MALE
end

Factory.define :incoming_female_form, parent: :incoming_apply_form do |f|
  f.gender Person::FEMALE
  f.association :volunteer, factory: :female
end

Factory.define :paid_form, parent: :apply_form do |f|
  f.after_create do |form|
     Factory.create(:workcamp_assignment, apply_form: form)
     form.reload
  end
end

Factory.define :paid_ltv_form, parent: :apply_form, class: Ltv::ApplyForm do |f|
  f.after_create do |form|
     Factory.create(:workcamp_assignment, apply_form: form)
     form.reload
  end
end


Factory.define :form_male, parent: :apply_form do |f|
  f.gender Person::MALE
  f.association :volunteer, factory: :male
end


Factory.define :form_female, parent: :paid_form do |f|
  f.gender Person::FEMALE
  f.association :volunteer, factory: :female
end


Factory.define :accepted_form, parent: :apply_form do |f|
  f.after_create do |form|
    Factory.create(:workcamp_assignment, apply_form: form, accepted: Time.now )
    form.reload
  end
end

Factory.define :rejected_form, parent: :apply_form do |f|
  f.after_create do |form|
    Factory.create(:workcamp_assignment, apply_form: form, rejected: Time.now )
    form.reload
  end
end

# == Schema Information
#
# Table name: apply_forms
#
#  id                           :integer          not null, primary key
#  volunteer_id                 :integer
#  fee                          :decimal(10, 2)   default(2200.0), not null
#  cancelled                    :datetime
#  general_remarks              :text
#  motivation                   :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  current_workcamp_id_cached   :integer
#  current_assignment_id_cached :integer
#  type                         :string(255)      default("Outgoing::ApplyForm"), not null
#  confirmed                    :datetime
#  organization_id              :integer
#  country_id                   :integer
#  firstname                    :string(255)
#  lastname                     :string(255)
#  gender                       :string(255)
#  email                        :string(255)
#  phone                        :string(255)
#  birthnumber                  :string(255)
#  occupation                   :string(255)
#  account                      :string(255)
#  emergency_name               :string(255)
#  emergency_day                :string(255)
#  emergency_night              :string(255)
#  speak_well                   :string(255)
#  speak_some                   :string(255)
#  fax                          :string(255)
#  street                       :string(255)
#  city                         :string(255)
#  zipcode                      :string(255)
#  contact_street               :string(255)
#  contact_city                 :string(255)
#  contact_zipcode              :string(255)
#  birthplace                   :string(255)
#  nationality                  :string(255)
#  special_needs                :text
#  past_experience              :text
#  comments                     :text
#  note                         :text
#  birthdate                    :date
#  passport_number              :string(255)
#  passport_issued_at           :date
#  passport_expires_at          :date
#
