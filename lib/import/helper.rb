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
          wc = handle_workcamp_node(node)
          wc.save! if options[:save]
          wcs << wc
          info "Workcamp #{wc.name}(#{wc.code}) imported."
        rescue Import::ImportException, ActiveRecord::ActiveRecordError => e
          error e.message
        end
      end

      return wcs
    end

    protected

    def import_defaults(wc)
      wc.publish_mode = 'SEASON'
      wc.state = 'imported'
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
