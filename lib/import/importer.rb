module Import

  class Error < Exception
  end

  module Importer

    include InexRules
    include IntentionsHelper

    def import!(&reporter)
      import( :save => true, &reporter)
    end

    # TODO: make submethods
    def import(options = {}, &reporter)
      @reporter = reporter
      wcs = []

      each_workcamp do |node|
        begin
          if wc = make_workcamp(node)
            setup_imported_workcamp(wc)

            if old = find_workcamp_like(wc)
              old.import_changes.create_by_diff(wc)

              if old.import_changes.size == 0
                info "Workcamp #{wc.name}(#{wc.code}) did not change."
                return nil
              end

              wc = old
              wc.state = 'updated'
              info "Workcamp #{wc.name}(#{wc.code}) prepared for update."
            else
              wc.state = 'imported'
              info "Workcamp #{wc.name}(#{wc.code}) prepared for creation."
            end

            wc.save! if options[:save]
            wcs << wc
          end
        rescue ActiveRecord::ActiveRecordError => e
          error e.message
        end
      end

      return wcs
    end

    def find_workcamp_like(wc)
      query = Outgoing::Workcamp.where(code: wc.code)
      query = query.by_year(wc.begin.year) if wc.begin
      query.first
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
