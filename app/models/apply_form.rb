# == Schema Information
#
# Table name: apply_forms
#
#  id                           :integer          not null, primary key
#  volunteer_id                 :integer
#  fee                          :decimal(10, 2)   default(2200.0), not null
#  cancelled                    :datetime
#  general_remarks              :text
#  motivation                   :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  current_workcamp_id_cached   :integer
#  current_assignment_id_cached :integer
#  type                         :string(255)      default("Outgoing::ApplyForm"), not null
#  confirmed                    :datetime
#

require 'rexml/document'


# TODO - set new AF fee smartly
class ApplyForm < ActiveRecord::Base
  include Alerts

  acts_as_taggable
  enforce_schema_rules
  create_date_time_accessors

  named_scope :year, lambda { |year|
    year = year.to_i
    sql = '(created_at >= ? AND created_at < ?)'
    { :conditions => [ sql, Date.new(year,1,1), Date.new(year + 1,1,1) ] }
  }

  def name
    who = (volunteer)? volunteer.name : '(?)'
    "#{who} (#{I18n.localize(self.created_at.to_date)})"
  end

  def to_label
    name
  end

  def toggle_cancelled
    toggle_date(:cancelled)
  end

  # Cancels the form and returns self to enable method chaining.
  def cancel
    self.cancelled = Time.now
    save!
    self
  end

  def cancelled?
    not cancelled.nil?
  end

  private

  def toggle_date(attr)
    if send("#{attr}?")
      self.send("#{attr}=", nil)
    else
      self.send("#{attr}=", Time.zone.now)
    end

    save!
    self
  end

end
