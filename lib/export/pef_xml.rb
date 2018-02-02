module Export
  class PefXml
  def initialize(wc, user = nil)
    @wc = wc
    @user = user
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
        xml.organization      @wc.organization.code
        xml.organization_code @wc.organization.name
        xml.ho_description    inex

        xml.projects do
          xml.project(id: @wc.project_id) do
	    xml.code @wc.code
	    xml.name @wc.name

            if @wc.latitude && @wc.longitude
              xml.lat_project @wc.latitude
              xml.lng_project @wc.longitude
            end

            xml.start_date @wc.from.strftime
            xml.end_date   @wc.to.strftime
            xml.location   @wc.area
            xml.description @wc.description
            xml.descr_partner @wc.partner
            xml.descr_accomodation_and_food @wc.accomodation



            if @wc.project_summary
              xml.project_summary @wc.project_summary
            end
          end

        end
      }
    end.to_xml
  end

  private

  def inex
    # TODO: use @wc.organization.description
    "INEX-SDA is a Czech non-governmental, non-profit organisation, founded in 1991. Our primary activities are aimed at the area of international voluntary work. We believe in volunteering and individual initiative, in direct experience and critical thinking, in understanding and respect towards diversity and in personal responsibility and sustainable development."
  end

  def filename
    code = @wc.code.strip.gsub(/\w/,'_')
    [ "PEF", code,".xml" ].join
  end
end
