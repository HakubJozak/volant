module Import

  class Error < Exception
  end

  module Importer

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
            wc.publish_mode = 'SEASON'
            compute_free_places(wc)

            if old = find_workcamp_like(wc)
              old.import_changes.delete_all
              old.diff(wc).each do |field,value|
                next if [:created_at, :updated_at, :state,:free_places_for_males,
                         :free_places_for_females, :free_places,:starred].include?(field)
                old.import_changes.build field: field.to_s, value: value.last
              end

              if old.import_changes.size == 0
                info "Workcamp #{wc.name}(#{wc.code}) did not change."
              else
                wc = old
                wc.state = 'updated'
                info "Workcamp #{wc.name}(#{wc.code}) prepared for update."
                wc.save!
                wcs << wc
              end
            else
              wc.state = 'imported'
              success "Workcamp #{wc.name}(#{wc.code}) prepared for creation."
              wc.save!
              wcs << wc
            end
          end
        rescue ActiveRecord::ActiveRecordError,Import::Error => e
          error e.message
        end
      end

      wcs
    end

    def find_workcamp_like(wc)
      Outgoing::Workcamp.find_by_project_id(wc.project_id) || guess_by_code_and_year(wc)
    end

    def error(msg)
      Rails.logger.warn(msg)
      @reporter.call(:error, msg) if @reporter
    end

    def warning(msg)
      Rails.logger.warn(msg)
      @reporter.call(:warning, msg) if @reporter
    end

    def info(msg)
      Rails.logger.info(msg)
      @reporter.call(:info, msg) if @reporter
    end

    def success(msg)
      Rails.logger.info(msg)
      @reporter.call(:success, msg) if @reporter
    end


    private

    def compute_free_places(wc)
      if wc.capacity == nil or wc.capacity > 7
        wc.places = 2
      else
        wc.places = 1
      end

      wc.places_for_females = [ wc.places, wc.capacity_females ].compact.min
      wc.places_for_males = [ wc.places, wc.capacity_males ].compact.min
    end

    def guess_by_code_and_year(wc)
      query = Outgoing::Workcamp.where(code: wc.code)
      query = query.year(wc.begin.year) if wc.begin
      query.first
    end

  end
end
