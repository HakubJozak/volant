require "#{Rails.root}/app/models/outgoing/workcamp_assignment"

module Outgoing
  class Workcamp < ::Workcamp
    create_date_time_accessors

    include Outgoing::FreePlacesUpdater
    before_save :update_free_places_for_workcamp

    validates_presence_of :name

    # TODO: DRY
    scope :live, -> { where "state IS NULL" }
    scope :imported, -> { where "state = 'imported'" }
    scope :updated, -> { where "state = 'updated'" }
    scope :imported_or_updated, -> { where "state = 'imported' or state = 'updated'" }

    has_many :workcamp_assignments, :dependent => :destroy, :class_name => 'Outgoing::WorkcampAssignment'
    has_many :apply_forms, :through => :workcamp_assignments, :dependent => :destroy, :class_name => 'Outgoing::ApplyForm'
    has_many :import_changes, :dependent => :delete_all, :extend => ImportChange::Maker

    has_many :accepted_forms, -> { readonly.where("#{ApplyForm.table_name}.cancelled IS NULL and #{WorkcampAssignment.table_name}.accepted IS NOT NULL") }, :through => :workcamp_assignments,             :class_name => 'Outgoing::ApplyForm',
             :source => :apply_form

    # def free_places
    #   self.places - self.accepted_places
    # end

    # def free_places_for_males
    #   [ free_places, places_for_males - accepted_places_males ].min
    # end

    # def free_places_for_females
    #   [ free_places, places_for_females - accepted_places_females ].min
    # end

    # TODO: DRY
    def imported?
      self.state == 'imported'
    end

    # TODO: DRY
    def updated?
      self.state == 'updated'
    end

    # TODO: separate apply_changes! and import!
    def import!
      return unless imported? or updated?

      Outgoing::Workcamp.transaction do
        import_changes.each do |change|
          change.apply(self)
          change.destroy
        end

        self.state = nil
        save!
      end
    end

    def cancel_import!
      Outgoing::Workcamp.transaction do
        if imported?
          self.destroy
        elsif updated?
          import_changes.destroy_all
          self.state = nil
          self.save!
        end
      end
    end

    # Turns all 'imported' workcamps into normal workcamps.
    #
    def self.import_all!
      imported_or_updated.find_each do |wc|
        wc.import!
      end
    end

    def self.cancel_import!
      imported_or_updated.find_each { |wc| wc.cancel_import! }
    end

    def self.find_by_name_or_code(text)
      search = "%#{text.downcase}%"
      where('lower(name) LIKE ? or lower(code) LIKE ?', search, search).order('"begin" DESC, code ASC, name ASC').limit(15)
    end

  end
end
