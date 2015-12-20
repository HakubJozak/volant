module Import
  class AllianceImporter

    include XmlHelper

    def initialize(filename)
      @tag = File.basename(filename)
      @doc = REXML::Document.new(File.new(filename))
    end


    def import
      result = []

      @doc.elements.each('/exportfile/workcamps') do |node|
        code = node.attributes['organization']
        organization = Organization.find_by_code(code)

        if organization == nil
          result << {  :unknown_organization => code }
          Rails.logger.error "ERROR: Unknown #{code}"
        else
          Rails.logger.info "Organization #{organization.code}"
          wcresult = []

          node.elements.each('workcamp') do |wc|
            wcresult << handle_workcamp_node(wc, organization)
          end

          ok_count = wcresult.select { |r| r.key?(:workcamp) }.size
          parsed_count = wcresult.size

          Rails.logger.info "Parsed count: #{parsed_count}"
          Rails.logger.info "Affected count: #{ok_count}"


          result << { :organization => {
              :name => organization.name,
              :workcamps => wcresult,
              :ok_count => ok_count,
              :parsed_count => parsed_count }}
        end
      end

      result
    end

    protected

    def existing?(node)
      name = to_text(node, 'name')
      code = to_text(node, 'code')
      from = to_date(node, 'start_date')
      to = to_date(node, 'end_date')

      params = { :code => code, :name => name, :begin => from, :end => to }
      Workcamp.find( :first, :conditions => params)
    end

    def handle_workcamp_node( node, organization)
      begin
        warnings = []
        code = to_text(node, 'code')

        if (wc = existing?(node))
          Rails.logger.warn "WARNING: Workcamp '#{code}' already exists"
          return { :wc_already_exists => code }
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

          wc.description = to_text(node, 'description')
          wc.notes = to_text(node, 'notes')
          wc.airport = to_text(node, 'airport')
          wc.train = to_text(node, 'train_station')
          wc.area = to_text(node, 'location')
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

        workcamp.save!
        Rails.logger.info " - Imported #{workcamp.code} - #{workcamp.name}"
        return { :workcamp => { :name => workcamp.name, :code => workcamp.code, :warnings => warnings } }
      rescue ActiveRecord::RecordInvalid => invalid
        cause = invalid.record.errors.full_messages.join(',')
        Rails.logger.error " - ERROR: #{cause}"
        return { :error => cause }
      rescue
        raise
        Rails.logger.error " - ERROR: #{$!}"
        return { :error => $! }
      end
    end


  end
end
