class VolunteerSerializer < Barbecue::BaseSerializer

   writable_attributes :firstname, :lastname, :gender,
  :email, :phone,
      :speak_well, :speak_some,
      :birthdate, :birthnumber, :birthplace,
      :nationality, :occupation, :account, :emergency_name,
      :emergency_day, :emergency_night,
      :special_needs, :past_experience, :comments,
      :fax, :street, :city, :zipcode,
      :contact_street, :contact_city, :contact_zipcode,
      :note

  readonly_attributes :id, :age
end

# class ParticipantSerializer < VolunteerSerializer
#   has_one :country, embed: :ids, include: true
#   has_one :organization, embed: :ids, include: true
#   has_one :workcamp, embed: :ids, include: true
# end
