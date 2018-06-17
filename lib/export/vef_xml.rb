class Export::VefXml < Export::VefBase
  def sufix
    'xml'
  end

  def emergency_contact
    [ @form.emergency_name,
      @form.emergency_day,
      @form.emergency_email ].compact.join(',')
  end

  def address1
    [@form.street, @form.city].compact.join(',')
  end

  def address2
    @form.zipcode
  end

  ADIH_OCCUPATIONS = {
    'STH' => 'Highschool Student',
    'STU' => 'University Student',
    'EMP' => 'Employed / Self-employed',
    'UNE' => 'Unemployed',
    'OTH' => 'Other',
  }

  def occupation
    o = @form.occupation.to_s

    if ADIH_OCCUPATIONS.keys.include?(o.upcase)
      o.upcase
    elsif o.blank?
      'UNE'
    elsif o =~ /student/i
      'STU'
    else
      'EMP'
    end
  end

  def contact_address1
    [@form.contact_street, @form.contact_city].compact.join(',')
  end

  def contact_address2
    @form.contact_zipcode
  end

  def country
    if @form.respond_to?(:country) and @form.country
      @form.country.code
    else
      'CZ'
    end
  end

  def to_xml(options = {})
    f = @form
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.vef {
        xml.sender 'SDA'
        xml.version '1.0'
        xml.application 'Volant'
        xml.date_filed (f.created_at || Date.today).to_date.strftime

        xml.firstname f.firstname
        xml.lastname  f.lastname
        xml.sex f.gender.try(:upcase)
        xml.birthdate f.birthdate.try(:to_date).try(:strftime)
        xml.birthplace f.birthplace
        xml.address1 address1
        xml.address2 address2

        xml.zip f.zipcode
        xml.city f.city
        xml.country country
        xml.email f.email
        xml.telephone f.phone

        xml.tmp_address1 contact_address1
        xml.tmp_address2 contact_address1
        xml.tmp_zip f.contact_zipcode
        xml.tmp_city f.contact_city
        xml.tmp_country country

        if f.speak_well.present?
          xml.language1 f.speak_well
          xml.langlevel1 3
        end

        if f.speak_some.present?
          xml.language2 f.speak_some
          xml.langlevel2 2
        end

        xml.emergency_contact emergency_contact
        xml.occupation occupation

        xml.special_needs f.special_needs
        xml.remarks f.general_remarks
        xml.nationality f.nationality
        xml.experience f.past_experience
        xml.motivation f.motivation
        # disability

        f.workcamps.each_with_index do |wc,i|
          xml.send("choice#{i+1}",wc.code)
        end
      }
    end
    builder.to_xml
  end

  alias :data :to_xml
end
