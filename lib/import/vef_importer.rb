module Import
  class VefImporter
    def initialize(file)
      @errors = []
      @doc = File.open(file) { |f| Nokogiri::XML(f) }	      
    end

    def import
      Incoming::ApplyForm.create do |a|
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
      end
    rescue ArgumentError => e
      @errors << e.message
      false
    end

    private

    def text(name)
      field(name).try(:text).to_s
    end

    def set_address(record, prefix = '', xml_prefix = '')
      a1 = text("#{xml_prefix}address1")
      a2 = text("#{xml_prefix}address2")

      street = [ a1, a2 ].join(', ')
      record.public_send("#{prefix}street=", street)

      %i( city zipcode ).each do |attr|
        value = text("#{xml_prefix}#{attr}")
        record.public_send("#{prefix}#{attr}=", value)        
      end
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
