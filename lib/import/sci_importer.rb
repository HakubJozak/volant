module Import
  class SciImporter
    include XmlHelper
    include Import::Helper

    def initialize(file)
      @doc = FasterCSV.new(file.read,
                           :col_sep => ',',
                           :quote_char => '"',
                           :return_headers => false,
                           :headers => :first_row)
    end

    def import(options = {}, &reporter)
      wcs = []

      @doc.each do |line|
        workcamp = Outgoing::Workcamp.new do |wc|

        end

        wc.save! if options[:save]
        wcs << workcamp
      end

      wcs
    end

  end
end
