# -*- coding: utf-8 -*-
# FIXME - move to Outgoing module
class Volunteer < Person
  include CzechUtils

  create_date_time_accessors

  validates_presence_of :firstname, :lastname, :birthnumber, :occupation, :birthdate, :email,
                        :phone, :gender, :street, :city, :zipcode, :emergency_name, :emergency_day


  has_many :apply_forms, :class_name => 'Outgoing::ApplyForm'

  scope :named, -> { where('rejected IS NULL') }

  CSV_FIELDS = %w(firstname lastname age gender email phone birthdate birthnumber nationality occupation city contact_city)

  scope :query, lambda { |query|
    unless query.blank?
      like = "%#{query}%"
      str = """
            firstname ILIKE ? or
            lastname ILIKE  ? or
            birthnumber ILIKE ? or
            phone ILIKE ? or
            email ILIKE ?
           """
      where(str,like, like, like,like,like)
    end
  }




  def self.find_by_name_like(text)
    search = "%#{text.downcase}%"
    Volunteer.where("lower(lastname) LIKE ? or lower(firstname) LIKE ?", search, search).order('lastname ASC, firstname ASC').limit(15)
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


end
