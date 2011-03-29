module Import

  class ImportException < Exception
  end

  module Importer

    include InexRules
    include IntentionsHelper

    def import!(&reporter)
      import( :save => true, &reporter)
    end

    def import(options = {}, &reporter)
      @reporter = reporter
      wcs = []

      each_workcamp do |node|
        begin
          if wc = make_workcamp(node)
            if old = Outgoing::Workcamp.find_duplicate(wc)
              old.import_changes.create_by_diff(wc)
              wc = old
              info "Workcamp #{wc.name}(#{wc.code}) prepared for update."
            else
              setup_imported_workcamp(wc)
              wc.save! if options[:save]
              info "Workcamp #{wc.name}(#{wc.code}) prepared for creation."
            end

            wcs << wc
          end
        rescue Import::ImportException, ActiveRecord::ActiveRecordError => e
          error e.message
        end
      end

      return wcs
    end

    def error(msg)
      Rails.logger.warn(msg)
      @reporter.call(:error, msg) if @reporter
    end

    # TODO: real warning
    alias :warning :error

    def info(msg)
      Rails.logger.info(msg)
      @reporter.call(:info, msg) if @reporter
    end

  end
end
