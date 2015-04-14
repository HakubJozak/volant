# -*- coding: utf-8 -*-
class Workcamp < ActiveRecord::Base

  include AllianceExporter
  include ActiveRecord::Diff
  include Import::WorkcampExtension
  include Stars::Model

  create_date_time_accessors

  include FreePlacesUpdater
  before_save :update_free_places_for_workcamp

  has_many :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::WorkcampAssignment'
  has_many :apply_forms, through: :workcamp_assignments, dependent: :destroy, class_name: 'ApplyForm'

  validates_presence_of :country, :code, :name, :places, :places_for_males, :places_for_females, :organization, :publish_mode
  validates_presence_of :extra_fee_currency, :if => Proc.new {|wc| wc.extra_fee && wc.extra_fee > 0},:message => "je povinná. (Je vyplněn poplatek, ale nikoliv jeho měna. Doplňte měnu poplatku.)"


  scope :published, -> (season_end) { where %{(publish_mode = 'ALWAYS') OR (publish_mode = 'SEASON' AND "begin" <= ?  AND "begin" >= current_date)},season_end}


  scope :year, lambda { |year|
    year = year.to_i
    where '(extract(YEAR from workcamps.begin) = ? OR extract(YEAR FROM workcamps.end) = ?)', year,year
  }

  scope :free, -> (at_least = 1) {
    where("free_places >= ?",at_least)
  }  

  DURATION_SQL = '(EXTRACT(epoch FROM age("end","begin"))/(3600 * 24) + 1)'

  scope :min_duration, lambda { |d| where("(duration IS NULL AND #{DURATION_SQL} >= ?) OR duration >= ?", d,d) }

  scope :max_duration, lambda { |d| where("(duration IS NULL AND #{DURATION_SQL} <= ?) OR duration <= ?", d,d) }

  scope :query, lambda { |query|
    like = "%#{query}%"
    where("workcamps.name ILIKE ? or workcamps.code ILIKE ?",like,like)
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

  # same country, same intentions
  scope :similar_to, lambda { |wc|
    same_intentions = wc.intentions.map(&:id)
    where(country_id: wc.country_id).where("id <> ?",wc.id).with_workcamp_intentions(*same_intentions)
  }

  scope :filter_by_hash, lambda { |filter,current_user|
    search = where('TRUE')

    if filter[:state]
      search = search.imported_or_updated
    end

    if mode = filter[:publish_mode]
      search = search.where(publish_mode: mode)
    end

    if q = filter[:q].presence
      search = search.query(q)
    end

    if filter[:starred]
      search = search.starred_by(current_user)
    end

    if from = filter[:from]
      search = search.where("begin >= ?",Date.parse(from))
    end

    if to = filter[:to]
      search = search.where("\"end\" <= ?",Date.parse(to))
    end

    if md = filter[:min_duration]
      search = search.min_duration(md)
    end

    if md = filter[:max_duration].presence
      search = search.max_duration(md)
    end

    if age = filter[:age].presence
      search = search.where("minimal_age <= ? and maximal_age >= ?",age,age)
    end

    if fp = filter[:free]
      search = search.where("free_places >= ?",fp)
    end

    if fp = filter[:free_females]
      search = search.where("free_places_for_females >= ?",fp)
    end

    if fp = filter[:free_males]
      search = search.where("free_places_for_males >= ?",fp)
    end

    if ids = filter[:tag_ids].presence
      search = search.with_tags(*ids)
    end

    if ids = filter[:workcamp_intention_ids].presence
      search = search.with_workcamp_intentions(*ids)
    end

    if ids = filter[:country_ids].presence
      search = search.with_countries(*ids)
    end

    if ids = filter[:organization_ids].presence
      search = search.with_organizations(*ids)
    end

    search
  }


  def self.find_by_project_id(project_id)
    if project_id.present?
      where(project_id: project_id).first
    else
      nil
    end
  end


  # TODO - fix tests and allow validation
  #  validates_inclusion_of :publish_mode, :in => [:always, :season, :never,:ltv ]

  # CSV_FIELDS = %w(name code country organization)
  # acts_as_convertible_to_csv :fields => CSV_FIELDS, :format_options => {
  #                                                 :country => :format_for_csv,
  #                                                 :organization => :format_for_csv
  #                                                  :networks => :format_for_csv
  #                                                 }

  belongs_to :country
  belongs_to :organization

  # TODO: make it workcamp_intentions
  has_and_belongs_to_many :intentions,  -> { readonly },
                          validate: false, class_name: 'WorkcampIntention',
                          join_table: 'workcamp_intentions_workcamps',
                          delete_sql: 'DELETE FROM workcamp_intentions_workcamps WHERE workcamp_id=#{id}'
  alias :workcamp_intention_ids= :intention_ids=

  acts_as_taggable
  include TaggableExtension

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
