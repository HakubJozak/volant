module Export
  class PefXml

    def initialize(subject, user = nil)
      if subject.is_a? Workcamp
        @workcamps = [ subject ]
        @organization = subject.organization
      elsif subject.respond_to? :each
        @workcamps = subject
        @organization = subject.first.organization
      else
        fail "Unsupported subject type #{subject.inspect}"
      end
        
      @user = user
    end

    def filename
      date = Date.today.strftime("%Y%m%d")
      
      if @workcamps.size == 1
        code = @workcamps.first.code.strip.gsub(/\s+/,'_')
      else
        code = @organization.code.strip.gsub(/\s+/,'_')
      end

      "PEF_#{code}_#{date}.xml"        
    end

    # public for testing
    def iso_language_codes(str)
      str.split(%r{and|,|\.|/}).map do |lang|
        name = lang.strip.downcase
        definition =
          ISO_639.find_by_english_name(name.capitalize).presence ||
          ISO_639.find(name).presence ||
          ISO_639.find_by_code(name.downcase).presence ||
          ISO_639.search(name.downcase).first
        
        definition.try :alpha3
      end.compact
    end

    def to_xml
      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.projectform {
          xml.network           "ALLIANCE"
          xml.application       "Volant"
          xml.date_filed        Date.today.to_date.strftime
          xml.version           "1.0"
          xml.pef_sent_by       @user.try(:name)
          xml.pef_sender_email  @user.try(:email)
          xml.organization      @organization.name.strip
          xml.organization_code @organization.code.strip
          xml.ho_description    @organization.description

          xml.projects do
            @workcamps.each do |wc|
              export_one_workcamp(xml, wc)              
            end
          end
        }
      end.to_xml
    end

    private

    def export_one_workcamp(xml, wc)
      xml.project(id: wc.project_id) do
	xml.code wc.code
	xml.name wc.name
        xml.work wc.intentions.map { |i| i.code }.join(',')
        xml.project_type wc.adih_project_type

        xml.min_age wc.minimal_age
        xml.max_age wc.maximal_age

        xml.numvol wc.capacity
        xml.numvol_m wc.capacity_males
        xml.numvol_f wc.capacity_females
        xml.max_national_vols wc.capacity_natives
        xml.max_teenagers wc.capacity_teenagers
        xml.max_vols_per_country 2

        xml.start_date wc.from.strftime if wc.from
        xml.end_date   wc.to.strftime if wc.to

        xml.country   wc.country.triple_code
        xml.region wc.region
        xml.airport wc.airport
        xml.train_bus_station wc.train
        xml.location wc.train

        if wc.latitude && wc.longitude
          xml.lat_project wc.latitude
          xml.lng_project wc.longitude
        end

        xml.description wc.description
        xml.descr_partner wc.partner_organization
        xml.descr_location_and_leisure wc.area
        xml.descr_work wc.workdesc
        xml.descr_requirements wc.requirements
        xml.descr_accomodation_and_food wc.accommodation
        xml.languages iso_language_codes(wc.language).join(',')

        if wc.extra_fee.present?
          xml.participation_fee wc.extra_fee
          xml.participation_fee_curency wc.extra_fee_currency
        end

        if wc.project_summary
          xml.project_summary wc.project_summary
        end

        xml.vegetarian bool(wc.tag_list.include?('vegetarian'))
        xml.family bool(wc.tag_list.include?('family'))
      end
    end

    def bool(flag)
      if flag
        '1'
      else
        '0'
      end
    end

    def inex
      @organization.description
    end
  end
end
