module Import

  class ImportException < Exception
  end

  class PefImporter

    include XmlHelper
    include InexRules


    def initialize(file)
      @doc = REXML::Document.new(file)
    end


    def import!(&reporter)
      self.import( :save => true, &reporter)
    end

    protected

    def import(options = {}, &reporter)
      @reporter = reporter

      @doc.elements.each('/projectform') do |node|
        org_code = to_text(node, 'organization_code')
        organization = Organization.find_by_code(org_code)

        if organization == nil
          error("Unknown organization #{org_code}")
          return []
        end

        wcs = []

        node.elements.each('projects/project') do |node|
          begin
            wc = handle_workcamp_node(node, organization)
            wc.save! if options[:save]
            wcs << wc
            info "Workcamp #{wc.name}(#{wc.code}) imported."
          rescue Import::ImportException, ActiveRecord::ActiveRecordError => e
            error e.message
          end
        end

        return wcs
      end
    end

    def error(msg)
      Rails.logger.warn(msg)
      @reporter.call(:error, msg) if @reporter
    end

    def info(msg)
      Rails.logger.info(msg)
      @reporter.call(:info, msg) if @reporter
    end

    def handle_workcamp_node( node, organization)
      begin
        warnings = []
        code = to_text(node, 'code')

        if existing?(node)
          raise ImportException.new("WARNING: Workcamp with code '#{code}' already exists")
        end

        workcamp = Outgoing::Workcamp.new do |wc|
          wc.publish_mode = 'SEASON'
          wc.state = 'imported'

          wc.country = Country.find_by_triple_code(node.elements['country'].text) || organization.country
          wc.organization = organization

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
