module Outgoing
  class WorkcampAssignment < ActiveRecord::Base

    include FreePlacesUpdater
    after_save :update_free_places
    after_destroy :update_free_places


    STATE_ORDER = [ :paid, :asked, :accepted, :infosheeted, :rejected, :cancelled, :not_paid, :after].freeze

    create_date_time_accessors

    belongs_to :apply_form, :class_name => 'Outgoing::ApplyForm'
    belongs_to :workcamp, :class_name => 'Outgoing::Workcamp'
    validates_presence_of :workcamp

    after_save :update_apply_form_cache
    after_destroy :update_apply_form_cache

    scope :not_rejected, :conditions => [ 'rejected IS NULL']

    [ "accept", "reject", "ask", "infosheet" ].each do |action|
      eval %{
      def #{action}(time = nil)
        time ||= Time.now
        self.update_attribute( "#{action}ed", time)
        self
      end
    }
    end

    # TODO - DRY - this should be dealt with on one place
    # returns one of symbols: :accepted, :rejected, :asked
    def state
      return :cancelled if self.apply_form.cancelled?

      [ :rejected, :infosheeted, :accepted, :asked ].each do |attr|
        return attr if self.send(attr)
      end

      self.apply_form.payment ? :paid : :not_paid
    end

    def to_label
      workcamp.name
    end

    def current?
      self.apply_form.current_assignment == self
    end

    def history?
      self.apply_form.current_assignment.order > self.order
    end

    # TODO - put into observer
    def update_apply_form_cache
      ApplyForm.update_cache_for(self.apply_form_id) if self.apply_form_id
    end
  end
end
