module Import

  class PefImporter

    include XmlHelper
    include Import::Helper

    def initialize(file)
      @doc = REXML::Document.new(file)
      org_code = to_text(@doc, '/projectform/organization_code')
      @organization = Organization.find_by_code(org_code)
    end

    def each_workcamp(&block)
      @doc.elements.each('/projectform/projects/project') do |node|
        yield(node)
      end
    end

    def make_workcamp(node)
        code = to_text(node, 'code')

        unless @organization
          raise ImportException.new("Unknown organization")
        end

        if existing?(node)
          raise ImportException.new("WARNING: Workcamp with code '#{code}' already exists")
        end

      Outgoing::Workcamp.new do |wc|
        wc.country = Country.find_by_triple_code(node.elements['country'].text) || @organization.country
        wc.organization = @organization

        # simple attributes
        wc.name = to_text(node, 'name')
        wc.code = code
        wc.begin = to_date(node, 'start_date')
        wc.end = to_date(node, 'end_date')

        wc.workdesc = to_text(node, 'descr_work')
        wc.area = to_text(node, 'descr_location_and_leisure')
        wc.accomodation =to_text( node, 'descr_accomodation_and_food')

        wc.workdesc = to_text(node, 'description')
        add_to_description(wc, node, 'descr_partner')
        add_to_description(wc, node, 'descr_location_and_leisure')

        add_to_description(wc, node, 'descr_requirements')

        wc.notes = to_text(node, 'notes')
        wc.airport = to_text(node, 'airport')
        wc.train = to_text(node, 'station')
        wc.region = to_text(node, 'region')

        wc.language = to_text(node, 'languages')

        wc.minimal_age = to_integer(node, 'min_age')
        wc.maximal_age = to_integer(node, 'max_age')
        wc.latitude = to_decimal(node, 'lat_project')
        wc.longitude = to_decimal(node, 'lng_project')

        # places managment
        # ignoring 'max_vols_per_country'
        wc.capacity = to_integer(node, 'numvol')
        wc.capacity_males = to_integer(node,'numvol_m')
        wc.capacity_females = to_integer(node,'numvol_f')
        wc.capacity_natives = to_integer(node, 'max_national_vols')
        wc.capacity_teenagers = to_integer(node, 'max_teenagers')

        # more complicated parsing
        parse_fee(node, wc)
        parse_intentions(node, wc)

        # tags
        wc.tag_list << 'vegetarian' if to_bool(node,'vegetarian')
        wc.tag_list << 'family' if to_bool(node,'family')
        wc.tag_list << 'disabled' if to_bool(node,'disabled_vols')
      end
    end

    def existing?(node)
      name = to_text(node, 'name')
      code = to_text(node, 'code')
      from = to_date(node, 'start_date')
      to = to_date(node, 'end_date')

      conditions = { :code => code, :name => name, :begin => from, :end => to }
      Workcamp.find( :first, :conditions => conditions)
    end

    def add_to_description(wc, node, name)
      if content = to_text(node, name)
        if wc.description
          wc.description << "\n\n" << content
        else
          wc.description = content
        end
      end
    end

  end
end
