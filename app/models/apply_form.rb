require 'rexml/document'


# TODO - set new AF fee smartly
class ApplyForm < ActiveRecord::Base
  include ::Alerts

  acts_as_taggable

  create_date_time_accessors

  scope :year, lambda { |year|
    year = year.to_i
    where "(#{ApplyForm.table_name}.created_at >= ? AND #{ApplyForm.table_name}.created_at < ?)", Date.new(year,1,1), Date.new(year + 1,1,1)    }

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
