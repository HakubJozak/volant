class PersonSerializer < ApplicationSerializer
   attributes :id, :age, :firstname, :lastname, :gender,
      :email, :phone,
      :speak_well, :speak_some,
      :birthdate, :birthnumber, :birthplace,
      :nationality, :occupation, :account, :emergency_name,
      :emergency_day, :emergency_night,
      :special_needs, :past_experience, :comments,
      :fax, :street, :city, :zipcode,
      :contact_street, :contact_city, :contact_zipcode,
      :note
end
