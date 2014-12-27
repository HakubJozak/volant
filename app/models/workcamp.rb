# -*- coding: utf-8 -*-
class Workcamp < ActiveRecord::Base

  include AllianceExporter
  include ActiveRecord::Diff
  include Import::WorkcampExtension
  include Stars::Model

  create_date_time_accessors

  include Outgoing::FreePlacesUpdater
  before_save :update_free_places_for_workcamp

  validates_presence_of :country, :code, :name, :places, :organization, :publish_mode
  validates_presence_of :extra_fee_currency, :if => Proc.new {|wc| wc.extra_fee && wc.extra_fee > 0},:message => "je povinná. (Je vyplněn poplatek, ale nikoliv jeho měna. Doplňte měnu poplatku.)"

  has_many :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::WorkcampAssignment'
  has_many :apply_forms, through: :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::ApplyForm'


  DURATION_SQL = '(EXTRACT(epoch FROM age("end","begin"))/(3600 * 24))'
  scope :min_duration, lambda { |d| where("#{DURATION_SQL} >= ?", d) }
  scope :max_duration, lambda { |d| where("#{DURATION_SQL} <= ?", d) }

  scope :year, lambda { |year|
    year = year.to_i
    where '(extract(YEAR from workcamps.begin) = ? OR extract(YEAR FROM workcamps.end) = ?)', year,year
  }

  # deprecated
  scope :by_year, lambda { |y| year(y) }

  scope :query, lambda { |query|
    wcs = self.arel_table
    arel = wcs[:name].matches("%#{query}%").or(wcs[:code].matches("%#{query}%"))
    where(arel)
  }

  scope :with_tags, lambda { |*ids|
    query = where('true')

    ids.each_with_index do |id,i|
      name = "taggings_#{i}"
      sql = %(INNER JOIN "taggings" as #{name} ON "#{name}"."taggable_id" = "workcamps"."id" AND "#{name}"."taggable_type" = 'Workcamp')
      query = query.joins(sql).where("#{name}.tag_id = ?",id)
    end

    query
  }

  scope :with_workcamp_intentions, lambda { |*ids|
    query = where('true')

    ids.each_with_index do |id,i|
      name = "intentions_#{i}"
      sql = %(INNER JOIN "workcamp_intentions_workcamps" as #{name} ON "#{name}"."workcamp_id" = "workcamps"."id")
      query = query.joins(sql).where("#{name}.workcamp_intention_id = ?",id)
    end

    query
  }

  scope :with_countries, lambda { |*ids|
    where("workcamps.country_id in (?)",ids)
  }

  scope :with_organizations, lambda { |*ids|
    where("workcamps.organization_id in (?)",ids)
  }



  # TODO - fix tests and allow validation
  #  validates_inclusion_of :publish_mode, :in => [:always, :season, :never,:ltv ]

  # CSV_FIELDS = %w(name code country organization)
  # acts_as_convertible_to_csv :fields => CSV_FIELDS, :format_options => {
  #                                                 :country => :format_for_csv,
  #                                                 :organization => :format_for_csv
  #                                                  :networks => :format_for_csv
  #                                                 }

  has_many :infosheets, :dependent => :destroy
  belongs_to :country
  belongs_to :organization

  # TODO: make it workcamp_intentions
  has_and_belongs_to_many :intentions,
                          -> { readonly },
                          :class_name => 'WorkcampIntention',
                          :join_table => 'workcamp_intentions_workcamps',
                          :delete_sql => 'DELETE FROM workcamp_intentions_workcamps WHERE workcamp_id=#{id}'
  alias :workcamp_intention_ids= :intention_ids=

  acts_as_taggable

  def tag_ids=(ids)
    loaded = ColoredTag.find(ids)
    strings = loaded.map(&:name).join(',')
    self.tag_list = strings
    self.tags
  end

  def duration
    if self.end and self.begin
      (self.end.to_time - self.begin.to_time).to_i / 1.day + 1
    else
      nil
    end
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

end
