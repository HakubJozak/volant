class Workcamp < ActiveRecord::Base
  include AllianceExporter

  # TODO: uncomment when AS is removed
  # default_scope :conditions => [ "state IS NULL" ]

  create_date_time_accessors
  enforce_schema_rules

  # TODO - fix tests and allow validation
  #  validates_inclusion_of :publish_mode, :in => [:always, :season, :never ]

  CSV_FIELDS = %w(name code country organization)
  acts_as_convertible_to_csv :fields => CSV_FIELDS, :format_options => {
                                                  :country => :format_for_csv,
                                                  :organization => :format_for_csv
#                                                  :networks => :format_for_csv
                                                 }

  has_many :infosheets, :dependent => :destroy
  belongs_to :country
  belongs_to :organization

  has_and_belongs_to_many :intentions,
                          :class_name => 'WorkcampIntention',
                          :join_table => 'workcamp_intentions_workcamps',
                          :readonly => true,
                          :delete_sql => 'DELETE FROM workcamp_intentions_workcamps WHERE workcamp_id=#{id}'

  attr_readonly :free_places, :free_places_for_males, :free_places_for_females
  validates_presence_of :country
  validates_presence_of :extra_fee_currency, :if => :extra_fee

  acts_as_commentable
  acts_as_taggable

  def to_label(options = {})
    "#{code} - #{name}(#{term})"
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
