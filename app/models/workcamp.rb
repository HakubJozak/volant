# -*- coding: utf-8 -*-
class Workcamp < ActiveRecord::Base
  validates_lengths_from_database

  attr_accessor :accepted_incoming_places, :accepted_incoming_places_males, :accepted_incoming_places_females

  # `begin` and `end` are deprecated names
  alias_attribute :from, :begin
  alias_attribute :to, :end

  include AllianceExporter
  include ActiveRecord::Diff
  include Import::WorkcampExtension
  include Stars::Model

  create_date_time_accessors

  include FreePlacesUpdater
  before_save :update_free_places_for_workcamp

  # CountryCounters should come AFTER FreePlacesUpdater
  include CountryFreeCounters::Workcamp
  after_save :update_country_free_counts
  after_destroy :update_country_free_counts

  has_many :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::WorkcampAssignment'
  has_many :apply_forms, through: :workcamp_assignments, dependent: :destroy, class_name: 'ApplyForm'
  has_many :bookings, dependent: :delete_all

  validates_presence_of :country, :code, :name, :places, :from,
                        :to,:places_for_males, :places_for_females,
                        :organization, :publish_mode

  validates_presence_of :extra_fee_currency, :if => Proc.new {|wc| wc.extra_fee && wc.extra_fee > 0},:message => "je povinná. (Je vyplněn poplatek, ale nikoliv jeho měna. Doplňte měnu poplatku.)"

  scope :web_default, -> {
    order(:begin,:name).live.published(Account.current.season_end)
  }

  scope :published, -> (season_end) {
    where %{(publish_mode = 'ALWAYS') OR (publish_mode = 'SEASON' AND "begin" <= ?)}, season_end
  }

  scope :future, -> {
    where('"begin" >= current_date')
  }

  scope :archive, -> {
    where('"end" < current_date')
  }

  scope :recently_created, -> {
    where('workcamps.created_at > ?',7.days.ago)
  }

  scope :urgent, -> {
    free.where('"begin" >= current_date AND "begin" <= ?',14.day.from_now)
  }

  scope :free, -> (at_least = 1) {
    where("free_places >= ?",at_least)
  }

  scope :year, lambda { |year|
    year = year.to_i
    where '(extract(YEAR from workcamps.begin) = ? OR extract(YEAR FROM workcamps.end) = ?)', year,year
  }

  DURATION_SQL = '(EXTRACT(epoch FROM age("end","begin"))/(3600 * 24) + 1)'

  scope :min_duration, lambda { |d| where("(duration IS NULL AND #{DURATION_SQL} >= ?) OR duration >= ?", d,d) }

  scope :max_duration, lambda { |d| where("(duration IS NULL AND #{DURATION_SQL} <= ?) OR duration <= ?", d,d) }

  scope :query, lambda { |query|
    fuzzy_like(query,'workcamps.name','workcamps.code','workcamps.description','workcamps.region','workcamps.workdesc','workcamps.region')
  }

  scope :with_workcamp_intentions, lambda { |*ids|
    query = where('true')
    # TODO: check if it is really safe
    ids_list = ids.map(&:presence).compact.map(&:to_i)

    joined = if ids_list.empty?
               'NULL'
             else
               ids_list.join(',')
             end

    sql = "SELECT workcamp_id FROM workcamp_intentions_workcamps WHERE workcamp_intention_id IN (#{joined})"
    rows = WorkcampIntention.connection.execute(sql)
    camp_ids = rows.values.flatten

    # conditions = ids.map.with_index do |id,i|
    #   relation_alias = "intentions_#{i}"
    #   join = %(INNER JOIN "workcamp_intentions_workcamps" as #{relation_alias} ON "#{relation_alias}"."workcamp_id" = "workcamps"."id")
    #   query = query.joins(join)
    #   "(#{relation_alias}.workcamp_intention_id = ?)"
    # end

    binding.pry
    
    where('workcamps.id in (?)',camp_ids)
  }

  scope :with_countries, lambda { |*ids|
    where("workcamps.country_id in (?)",ids.select(&:present?))
  }

  scope :with_organizations, lambda { |*ids|
    where("workcamps.organization_id in (?)",ids.select(&:present?))
  }

  # same country, same intentions
  scope :similar_to, lambda { |wc|
    same_intentions = wc.intentions.map(&:id)
    where(country_id: wc.country_id).where("id <> ?",wc.id).
      with_workcamp_intentions(*same_intentions)
  }

  scope :filter_by_hash, lambda { |filter,current_user|
    search = where('TRUE')

    if filter[:state]
      search = search.imported_or_updated
    else
      search = search.live
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

  def infosheet_all
    apply_forms.each do |form|
      if form.current_workcamp == self && form.accepted?
        form.infosheet
      end
    end
  end

  def all_applications_emails
    apply_forms.accepted.select(:email).map(&:email).join(', ')
  end

  def all_organizations_emails
    orgs = apply_forms.accepted.select(:organization_id).map(&:organization_id)
    mails = EmailContact.incoming.where('organization_id in (?)',orgs).select(:address).map(&:address)
    mails.join(', ')
  end

  public

  def accepts_age?(age)
    (self.minimal_age <= age) and (self.maximal_age >= age)
  end


  def capacity
    read_attribute(:capacity) || 0
  end

  def capacity_males
    read_attribute(:capacity_males) || capacity
  end

  def capacity_females
    read_attribute(:capacity_females) || capacity
  end

  def no_more_countries
    # TODO: test that only active are taken
    active = apply_forms.accepted.select { |form| form.current_workcamp == self }
    active.group_by { |f| f.country }.select { |c,v| v.size > 1 }.keys.compact
  end

  private

  def localize(date)
    date ? I18n.localize(date) : '?'
  end

end
