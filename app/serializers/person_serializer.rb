class PersonSerializer < ApplicationSerializer
   attributes :id, :age, :firstname, :lastname, :gender,
      :email, :phone,
      :speak_well, :speak_some,
      :birthdate, :birthnumber, :birthplace,
      :passport_expires_at, :passport_issued_at, :passport_number,
      :nationality, :occupation, :account, :emergency_name,
      :emergency_day, :emergency_email,
      :special_needs, :past_experience, :comments,
      :fax, :street, :city, :zipcode,
      :contact_street, :contact_city, :contact_zipcode

  def firstname
    object.firstname.to_s
  end

  def lastname
    object.lastname.to_s
  end
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
