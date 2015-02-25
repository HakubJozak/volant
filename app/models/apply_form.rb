require 'rexml/document'

class ApplyForm < ActiveRecord::Base
  include ::Alerts
  include Stars::Model

  acts_as_taggable
  include TaggableExtension
  include Export::Excel::ApplyForm

  create_date_time_accessors

  validates_presence_of :motivation

  belongs_to :current_workcamp, foreign_key: 'current_workcamp_id_cached', class_name: 'Workcamp'
  belongs_to :current_assignment, foreign_key: 'current_assignment_id_cached', class_name: 'Outgoing::WorkcampAssignment'
  has_many :workcamps, -> { order 'workcamp_assignments."order" ASC' }, through: :workcamp_assignments, class_name: 'Workcamp', validate: false
  has_many :workcamp_assignments, -> { order '"order" ASC' }, dependent: :delete_all, class_name: 'Outgoing::WorkcampAssignment', validate: false

  
  # TODO: replace by real DB attributes
  delegate :firstname, :lastname, :gender, :email, :phone, :birthdate, :birthnumber,
           :nationality, :occupation, :account, :emergency_name, :emergency_day,
           :emergency_night, :speak_well, :speak_some, :special_needs, :past_experience, :comments,
           :fax, :street, :city, :zipcode, :contact_street, :contact_city, :contact_zipcode,
           :birthplace, :note, to: :volunteer

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

  def cancel
    self.cancelled = Time.now
    save!
    self
  end

  def starred?(user)
    starrings.where(user: user).count > 0
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
