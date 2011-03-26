require "#{RAILS_ROOT}/app/models/outgoing/workcamp_assignment"

module Outgoing
  class Workcamp < ::Workcamp
    create_date_time_accessors

    has_many :workcamp_assignments, :dependent => :destroy, :class_name => 'Outgoing::WorkcampAssignment'
    has_many :apply_forms, :through => :workcamp_assignments, :dependent => :destroy, :class_name => 'Outgoing::ApplyForm'

    has_many :accepted_forms, :through => :workcamp_assignments, :readonly => true, :class_name => 'Outgoing::ApplyForm',
    :conditions => "#{ApplyForm.table_name}.cancelled IS NULL and #{WorkcampAssignment.table_name}.accepted IS NOT NULL",
    :source => :apply_form

    def free_places
      self.places - self.accepted_places
    end

    def free_places_for_males
      [ free_places, places_for_males - accepted_places_males ].min
    end

    def free_places_for_females
      [ free_places, places_for_females - accepted_places_females ].min
    end

    def imported?
      self.state == 'imported'
    end

    # Turns all 'imported' workcamps into normal workcamps.
    #
    def self.import_all!
      find_each(:conditions => "state = 'imported'") do |wc|
        wc.update_attribute :state, nil
      end
    end

    def self.find_by_name_or_code(text)
      search = "%#{text.downcase}%"
      find(:all,
           :conditions => ['lower(name) LIKE ? or lower(code) LIKE ?', search, search ],
           :order => '"begin" DESC, code ASC, name ASC',
           :limit => 15)
    end

  end
end
