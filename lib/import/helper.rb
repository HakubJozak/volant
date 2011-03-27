module Import

  class ImportException < Exception
  end

  module Helper

    include InexRules

    def import!(&reporter)
      import( :save => true, &reporter)
    end

    def import(options = {}, &reporter)
      @reporter = reporter
      wcs = []

      each_workcamp do |node|
        begin
          if wc = make_workcamp(node)
            setup_imported_workcamp(wc)
            wc.save! if options[:save]
            wcs << wc
            info "Workcamp #{wc.name}(#{wc.code}) imported."
          end
        rescue Import::ImportException, ActiveRecord::ActiveRecordError => e
          error e.message
        end
      end

      return wcs
    end

    protected

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
