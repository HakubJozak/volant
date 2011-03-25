module Import

  class ImportException < Exception
  end

  class PefImporter

    include XmlHelper
    include InexRules


    def initialize(filename)
      @tag = File.basename(filename)
      @doc = REXML::Document.new(File.new(filename))
    end


    def import
      @doc.elements.each('/projectform') do |node|
        org_code = to_text(node, 'organization_code')
        organization = Organization.find_by_code(org_code)

        raise ImportException.new("Unknown organization #{org_code}") if organization == nil

        wcs = []

        node.elements.each('projects/project') do |node|
          wcs << handle_workcamp_node(node, organization)
        end

        return wcs
      end
    end

    def import!(*args)
      wcs = self.import(*args)
      wcs.each { |wc| wc.save! }
      wcs
    end

    protected

    def handle_workcamp_node( node, organization)
      begin
        warnings = []
        code = to_text(node, 'code')

        if existing?(node)
          raise ImportException.new("WARNING: Workcamp '#{code}' already exists")
        end


        workcamp = Outgoing::Workcamp.new do |wc|
          wc.country = Country.find_by_triple_code(node.elements['country'].text) || organization.country
          wc.organization = organization
          wc.publish_mode = 'SEASON'

          # simple attributes
          wc.name = to_text(node, 'name')
          wc.code = code
          wc.begin = to_date(node, 'start_date')
          wc.end = to_date(node, 'end_date')

          wc.workdesc = to_text(node, 'descr_work')
          wc.area = to_text(node, 'descr_location_and_leisure')
          # TODO - sanitize better
          wc.workdesc = to_text(node, 'description')
          add_to_description(wc, node, 'descr_partner')
          add_to_description(wc, node, 'descr_location_and_leisure')
          add_to_description(wc, node, 'descr_accomodation_and_food')
          add_to_description(wc, node, 'descr_requirements')

          wc.notes = to_text(node, 'notes')
          wc.airport = to_text(node, 'airport')
          wc.train = to_text(node, 'station')
          wc.region = to_text(node, 'region')

          wc.language = to_text(node, 'languages')

          wc.minimal_age = to_integer(node, 'min_age')
          wc.maximal_age = to_integer(node, 'max_age')

          # places managment
          # ignoring 'max_vols_per_country'
          wc.capacity = to_integer(node, 'numvol')
          wc.capacity_males = to_integer(node,'numvol_m')
          wc.capacity_females = to_integer(node,'numvol_f')
          wc.capacity_natives = to_integer(node, 'max_national_vols')
          wc.capacity_teenagers = to_integer(node, 'max_teenagers')
          compute_places(wc)

          # more complicated parsing
          parse_fee(node, wc)
          parse_intentions(node, warnings, wc)

          # tags
          wc.tag_list << 'vegetarian' if to_bool(node,'vegetarian')
          wc.tag_list << 'family' if to_bool(node,'family')
          wc.tag_list << 'disabled' if to_bool(node,'disabled_vols')
          wc.tag_list << 'extra fee' if wc.extra_fee and wc.extra_fee > 0
          wc.tag_list << 'teenage' if wc.minimal_age and wc.minimal_age < 18

          wc.tag_list << @tag
        end

        return workcamp
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
