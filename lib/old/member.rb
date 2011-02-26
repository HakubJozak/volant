class Old::Member < Old::Gateway
  self.set_table_name 'member'
  self.primary_key = 'me_id'

  INVALID_EMAILS = ["nemá email","nemá e-mail","nema email","?",
                    "no address","","nemá mail","nemá"]

  def to_s
    "Member #{me_id}"
  end

  def migrate
    @new = Volunteer.new
    migrate_prefixed_fields 'me_', :firstname, :lastname,
    :fax, :comments,
    :occupation, :nationality,
    :birthdate, :birthnumber

    # will be removed after the migration
    migrate_naming :me_id, :old_schema_key

    migrate_naming :me_emergencycontact, :emergency_name
    migrate_naming :me_emdayphone, :emergency_day
    migrate_naming :me_emnightphone, :emergency_night
    migrate_naming :me_speakwell, :speak_well
    migrate_naming :me_speaksome, :speak_some
    migrate_naming :me_specialneeds, :special_needs
    migrate_naming :me_pastexperience, :past_experience

    migrate_unless_blank :street, ",", me_address1, me_address2
    migrate_naming :me_city, :city
    migrate_naming :me_zip, :zipcode

    migrate_unless_blank :contact_street, ",", me_address1, me_address2
    migrate_naming :me_city, :contact_city
    migrate_naming :me_zip, :contact_zipcode

#    migrate_unless_blank :address, "\n", me_address1, me_address2, me_city, me_zip # + co_id
#    migrate_unless_blank :contact_address, "\n", me_adress1_2, me_adress2_2, me_city_2, me_zip_2 # co_id_2

    if INVALID_EMAILS.include? me_email or me_email.strip.empty?
      migrate_field :email, nil
    else
      migrate_field :email, me_email.strip
    end

    migrate_unless_blank :phone, ',', me_mobile, me_phone, me_phone2

    migrate_field :gender, (me_male == '0')? 'f' : 'm'
    migrate_by_tag('vegetarian') if me_vegetarian
    migrate_by_tag('married') if me_maritalstatus.downcase == 'married'

    if me_accountnumber =~ /.*\/[0-9]{4}/ or me_bankcode.nil?
      account = me_accountnumber
    else
      account = "#{me_accountnumber}/#{me_bankcode}"
    end

    @new
  end

end
