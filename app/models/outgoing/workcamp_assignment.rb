# == Schema Information
#
# Table name: workcamp_assignments
#
#  id            :integer          not null, primary key
#  apply_form_id :integer
#  workcamp_id   :integer
#  order         :integer          not null
#  accepted      :datetime
#  rejected      :datetime
#  asked         :datetime
#  infosheeted   :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

module Outgoing
  class WorkcampAssignment < ActiveRecord::Base

    STATE_ORDER = [ :paid, :asked, :accepted, :infosheeted, :rejected, :cancelled, :not_paid, :after].freeze

    enforce_schema_rules
    create_date_time_accessors

    belongs_to :apply_form, :class_name => 'Outgoing::ApplyForm'
    belongs_to :workcamp, :class_name => 'Outgoing::Workcamp'
    validates_presence_of :workcamp

    named_scope :not_rejected, :conditions => [ 'rejected IS NULL']

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
    def after_save
      ApplyForm.update_cache_for(self.apply_form_id) if self.apply_form_id
    end

    def after_destroy
      ApplyForm.update_cache_for(self.apply_form_id) if self.apply_form_id
    end
  end
end
