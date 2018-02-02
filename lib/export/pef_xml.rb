module Export
  class PefXml

    def initialize(wc, user = nil)
      @wc = wc
      @organization = wc.organization
      @user = user
    end

    def filename
      code = @wc.code.strip.gsub(/\s+/,'_')
      date = Date.today.strftime("%Y%m%d")
      "PEF_#{code}_#{date}.xml"
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
          xml.organization      @organization.code
          xml.organization_code @organization.name
          xml.ho_description    @organization.description
          xml.work @wc.intentions.map { |i| i.code }.join(',')

          xml.projects do
            xml.project(id: @wc.project_id) do
	      xml.code @wc.code
	      xml.name @wc.name

              xml.min_age @wc.minimal_age
              xml.max_age @wc.maximal_age              

              xml.numvol @wc.capacity
              xml.numvol_m @wc.capacity_males
              xml.numvol_f @wc.capacity_females
              xml.max_national_vols @wc.capacity_natives
              xml.max_teenagers @wc.capacity_teenagers        
              xml.max_vols_per_country 2

              xml.start_date @wc.from.strftime if @wc.from
              xml.end_date   @wc.to.strftime if @wc.to

              xml.country   @wc.country.triple_code
              xml.location @wc.area
              xml.region @wc.region
              xml.airport @wc.airport
              xml.train_bus_station @wc.train

              if @wc.latitude && @wc.longitude
                xml.lat_project @wc.latitude
                xml.lng_project @wc.longitude
              end

              xml.description @wc.description
              xml.descr_partner @wc.partner_organization
              xml.descr_work @wc.workdesc
              xml.descr_requirements @wc.requirements
              xml.descr_accomodation_and_food @wc.accommodation
              xml.languages @wc.language
              
              if @wc.extra_fee.present?
                xml.participation_fee @wc.extra_fee
                xml.participation_fee_curency @wc.extra_fee_currency
              end

              if @wc.project_summary
                xml.project_summary @wc.project_summary
              end

              xml.vegetarian bool(@wc.tag_list.include?('vegetarian'))
              xml.family bool(@wc.tag_list.include?('family'))
            end
          end
        }
      end.to_xml
    end

    private

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


