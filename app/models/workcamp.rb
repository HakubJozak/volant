# -*- coding: utf-8 -*-
class Workcamp < ActiveRecord::Base

  include AllianceExporter
  include ActiveRecord::Diff

  create_date_time_accessors

  DURATION_SQL = '(EXTRACT(epoch FROM age("end","begin"))/(3600 * 24))'
  scope :min_duration, lambda { |d| where("#{DURATION_SQL} >= ?", d) }
  scope :max_duration, lambda { |d| where("#{DURATION_SQL} <= ?", d) }

  scope :by_year, lambda { |year|
    year = year.to_i
    where '(workcamps.begin >= ? AND workcamps.end < ?)', Date.new(year,1,1), Date.new(year + 1,1,1)
  }

  # TODO - fix tests and allow validation
  #  validates_inclusion_of :publish_mode, :in => [:always, :season, :never ]

  # CSV_FIELDS = %w(name code country organization)
  # acts_as_convertible_to_csv :fields => CSV_FIELDS, :format_options => {
  #                                                 :country => :format_for_csv,
  #                                                 :organization => :format_for_csv
  #                                                  :networks => :format_for_csv
  #                                                 }

  has_many :infosheets, :dependent => :destroy
  belongs_to :country
  belongs_to :organization

  has_and_belongs_to_many :intentions,
                          -> { readonly },
                          :class_name => 'WorkcampIntention',
                          :join_table => 'workcamp_intentions_workcamps',
                          :delete_sql => 'DELETE FROM workcamp_intentions_workcamps WHERE workcamp_id=#{id}'

  validates_presence_of :country, :code, :name, :places
  validates_presence_of :extra_fee_currency, :if => Proc.new {|wc| wc.extra_fee && wc.extra_fee > 0}, :message => "je povinná. (Je vyplněn poplatek, ale nikoliv jeho měna. Doplňte měnu poplatku.)"


  acts_as_taggable

  def self.find_duplicate(wc)
    scope = wc.begin ? by_year(wc.begin.year) : self
    scope.find_by_code(wc.code)
  end

  def to_label(options = {})
    "#{code} - #{name}(#{term})"
  end

  def duration
    if self.end and self.begin
      (self.end.to_time - self.begin.to_time).to_i / 1.day + 1
    else
      nil
    end
  end

  def term
    "#{localize(self.begin)} - #{localize(self.end)}"
  end

  def running?
    return false unless self.begin && self.end
    today = Date.today
    self.begin <= today && self.end >= today
  end

  def over?
    return false unless self.end
    self.end < Date.today
  end

  # TODO - implement
  def wanted
    false
  end

  # returns true if there is no more place left for volunteers of the same gender as 'volunteer'
  def full?(volunteer)
    self.send("free_places_for_#{volunteer.gender_sufix}") <= 0
  end

  # returns true if the workcamp is either 'full?' or it has been asked for all possible places
  def almost_full?(volunteer)
    return true if full?(volunteer)

    free = self.send("free_places_for_#{volunteer.gender_sufix}")
    asked = self.send("asked_for_places_#{volunteer.gender_sufix}")

    free <= asked
  end

  public

  def accepts_age?(age)
    (self.minimal_age <= age) and (self.maximal_age >= age)
  end


  def format_for_csv(field,object)
    case field
      when 'country' then object.country.name
      when 'organization' then self.organization.name
#      when 'networks' then self.organization.networks.map { |n| n.name }.join(",") if networks.size > 0
    end || ""
  end

  def to_xml(params = {})
    # this fix is needed because the view columns doesn't have properly recognized type
    params.update :methods => [ :free_places_for_females, :free_places_for_males, :free_places ],
                  :except => [ :free_places_for_females, :free_places_for_males, :free_places ]
    super(params)
  end

  private

  def localize(date)
    date ? I18n.localize(date) : '?'
  end

  protected

  def before_save
    self.places ||= 2
    self.places_for_males ||= 2
    self.places_for_females ||= 2
  end

end
