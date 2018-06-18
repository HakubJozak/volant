module Import
  class VefImporter

    def initialize(file)
      @errors = []
      @doc = if file.is_a? String
               File.open(file) { |f| Nokogiri::XML(f) }
             else
               Nokogiri::XML(file)
             end
    end

    def import(workcamp)
      participant = Incoming::Participant.create do |p|
        p.apply_form = create_form

        p.firstname = p.apply_form.firstname
        p.lastname = p.apply_form.lastname
        p.email = p.apply_form.email
        p.gender = p.apply_form.gender
        p.organization = organization
	p.country = organization.country
        p.workcamp = workcamp
      end

      if participant.valid?
        workcamp.workcamp_assignments.create!(
          apply_form: participant.apply_form,
          accepted: Time.now
        )
      end

      participant
    end

    private

    def create_form
      Incoming::ApplyForm.new do |a|
        a.organization = organization
        a.country = organization.country

        a.firstname = text 'firstname'
        a.lastname = text 'lastname'
        a.gender = sex
        a.email = text 'email'
        a.birthplace = text 'birthplace'
        a.birthdate = date 'birthdate'
        a.phone = telephone
        set_address(a)
        set_address(a, 'contact_', 'tmp_')
        a.occupation = text 'occupation'
        a.nationality = text 'nationality'
        a.motivation = text 'motivation'
        a.past_experience = text 'experience'
        a.passport_number = text 'passport'
        a.special_needs = text 'special_needs'
        a.general_remarks = text 'remarks'
        a.speak_well = languages { |lvl| lvl > 2 }
        a.speak_some = languages { |lvl| lvl < 3 }
        a.emergency_name = text 'emergency_contact'
      end
    end

    def organization
      @org ||= begin
                 code = text('sender')
                 Organization.find_by_code!(code)
               end
    end

    def text(name)
      field(name).try(:text).to_s
    end

    def languages(&lvl_picker)
      (1..4).each.map do |i|
        lang = text("language#{i}")
        lvl  = text("langlevel#{i}").to_i

        if lvl_picker.call(lvl)
          lang
        else
          nil
        end
      end.map(&:presence).compact.join(', ')
    end

    def set_address(record, prefix = '', xml_prefix = '')
      a1 = text("#{xml_prefix}address1")
      a2 = text("#{xml_prefix}address2")

      street = [ a1, a2 ].join(', ')
      record.public_send("#{prefix}street=", street)

      zip = text("#{xml_prefix}zip")
      record.public_send("#{prefix}zipcode=", zip)

      city = text("#{xml_prefix}city")
      record.public_send("#{prefix}city=", city)
    end

    def telephone
      fields = %i( cellphone telephone telephone2 telephone3 )
      phones = fields.map { |f| text(f).presence }.compact
      phones.join(', ')
    end

    def sex
      value = text('sex').downcase

      if %w( m male man ).include?(value)
        Person::MALE
      else
        Person::FEMALE
      end
    end

    def date(name)
      DateTime.strptime(field(name).text, '%Y-%m-%d')
    end

    def field(name)
      @doc.at_xpath("//vef/#{name}")
    end

  end
end
