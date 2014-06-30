# -*- coding: utf-8 -*-
# FIXME - move to Outgoing module
class Volunteer < Person
  create_date_time_accessors

  validates_presence_of :firstname, :lastname, :gender, :email
  has_many :apply_forms, :class_name => 'Outgoing::ApplyForm'
  named_scope :named, :conditions => [ 'rejected IS NULL']

  CSV_FIELDS = %w(firstname lastname age gender email phone birthdate birthnumber nationality occupation city contact_city)
  acts_as_convertible_to_csv  :fields => CSV_FIELDS

  def self.sql_for_name_search
    # concat the volunteer searchable fields to run fulltext search over them
    "(#{table_name}.firstname || ' ' || " +
    " #{table_name}.lastname  || ' ' || " +
    " #{table_name}.birthnumber  || ' ' || " +
    " #{table_name}.email)"
  end


  def self.with_birthdays_conditions
    query = "extract(day from birthdate) = ? and extract(month from birthdate) = ?"
    [ query, Date.today.day, Date.today.month ]
  end

  def self.find_with_birthday
    Volunteer.find(:all, :conditions => self.with_birthdays_conditions)
  end

  def self.find_by_name_like(text)
    search = "%#{text.downcase}%"
    Volunteer.find(:all,
                   :conditions => ['lower(lastname) LIKE ? or lower(firstname) LIKE ?', search, search ],
                   :order => 'lastname ASC, firstname ASC',
                   :limit => 15)
  end


  # Depending on hash parameters supplied tries either to:
  #
  # 1) find a volunteer by birthnumber, first name and lastname
  # 2) updates its parameters if found, otherwise creates a new volunteer
  # 3) returns created/updated volunteer together with code of action: :updated/:created/:created_but_uncertain
  #
  # TODO - move to lib
  def self.create_or_update(params)
    raise "no_birthnumber" unless params.has_key? 'birthnumber'
    raise "no_firstname" unless params.has_key? 'firstname'
    raise "no_lastname" unless params.has_key? 'lastname'

    found = Volunteer.find_by_birthnumber(params["birthnumber"])

    if found == nil
      [ Volunteer.new(params), :created ]
    elsif found.has_same_name?(params["firstname"], params["lastname"])
      found.attributes = params
      [ found, :updated ]
    else
      [ Volunteer.new(params), :created_but_uncertain ]
    end
  end

  # Compares supplied name with current, ignoring case and diacritics
  def has_same_name?(first, last)
    is_same_word(first,self.firstname) and is_same_word(last, self.lastname)
  end

  private

  # Returns true if the two words 'equals', ignoring diacritics and case
  def is_same_word(a,b)
    a = strip_cs_chars(a).downcase
    b = strip_cs_chars(b).downcase
    a == b
  end

  # ... by Frantisek Havluj
  def strip_cs_chars(src)
    accented_chars  = 'éěřťýúůíóášďžčňÉĚŘŤÝÚŮÍÓÁŠĎŽČŇ'
    ascii_chars     = 'eertyuuioasdzcnEERTYUUIOASDZCN'
    dest = src.dup

    (0...accented_chars.mb_chars.g_length).each do |i|
        dest.gsub!(accented_chars.mb_chars[i..i], ascii_chars[i..i])
    end

    dest
  end

end
