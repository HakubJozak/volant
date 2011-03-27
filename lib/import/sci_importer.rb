module Import
  class SciImporter
    include Import::Helper

    def initialize(file)
      @csv = FasterCSV.new(file.read,
                           :col_sep => ',',
                           :quote_char => '"',
                           :return_headers => false,
                           :headers => :first_row)
    end

    def each_workcamp(&block)
      @csv.each { |row| yield(row) }
    end

    def make_workcamp(row)
      data = row.to_hash
      organization = Organization.find_by_code(org_code = data["Code"])

      unless organization
        error "Unknown organization #{org_code}"
        return nil
      end

      Outgoing::Workcamp.new do |wc|
        wc.sci_id = data["ID"]
        wc.name = data["Camp Name"]
        wc.code = "#{data['Code']} #{data['Number']}"
        wc.organization = organization

        wc.country = Country.find_by_name_en(data['Country'])
        wc.capacity = data["N Vol"]
        wc.maximal_age = data["Max Intnl Age"]
        wc.minimal_age = data["Min Intnl Age"]

        wc.begin = data["Date Start"]
        wc.end = data["Date End"]
        import_intentions(data['Work Intentions'], wc)

        wc.description = data['Description']
        row.to_hash
      end
    end

    private

    # File actionpack/lib/action_controller/vendor/html-scanner/html/sanitizer.rb, line 32
    def sanitize(text, options = {})
      result = super
      # strip any comments, and if they have a newline at the end (ie. line with
      # only a comment) strip that too
      result.gsub!(/<!--(.*?)-->[\n]?/m, "") if result
      # Recurse - handle all dirty nested tags
      result == text ? result : sanitize(result, options)
    end

  end
end
