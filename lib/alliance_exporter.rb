module AllianceExporter

  class InvalidWorkcamp < StandardError
  end

  def self.export(workcamps)
    x = Builder::XmlMarkup.new
    
    x.instruct!
    result = x.exportfile(:network => 'alliance', :version => "1.0") do
      # hash workcamps by organization code
      by_orgs = workcamps.reduce(Hash.new) do |orgs,wc|
        code = wc.organization.code
	orgs[code] ||= []
        orgs[code] << wc
        orgs
      end
      
      by_orgs.each do |org_code, wc|
        x.workcamps(:organization => org_code) do |builder|
          workcamps.reduce('') do |str,wc|
            begin
              xml = wc.to_alliance_xml(builder) 
              str << xml
            rescue InvalidWorkcamp => e
              # TODO - tell it to the user
              Rails.logger.warn("Tried to export #{e}")
            end
          end
        end
      end
    end
  end

  # TODO - will become to_xml once the REST API is removed
  # x - XML builder or nil
  def to_alliance_xml(x = nil)
    raise InvalidWorkcamp.new(self) unless self.valid?
    x ||= Builder::XmlMarkup.new

    x.workcamp do
      x.name(name)
      x.code(code)
      x.country(country.triple_code)

      [[ 'start_date', self.begin ], [ 'end_date', self.end ]].each do |attr, date|
        raise InvalidWorkcamp.new("#{attr} is nil") unless date
        x.tag!(attr, date.strftime("%Y-%m-%d"))
      end

      # FIXME - real languages!
      x.languages('en')
      x.min_age(minimal_age)
      x.max_age(maximal_age)
      x.description(description)
      x.location(area)
      x.work intentions.map { |i| i.code }.join(',')

      # optional elements 
      x.numvol(capacity) if capacity
      x.numvol_f(capacity_females) if capacity_females
      x.numvol_m(capacity_males) if capacity_males
      
      # TODO - setup those values in organization policy?
      x.max_vols_per_country(2)
      x.max_teenagers if false
      x.max_national_vols if false
    end
  end

end
