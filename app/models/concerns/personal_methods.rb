module PersonalMethods
  extend ActiveSupport::Concern

  included do
    validates_presence_of :firstname, :lastname, :email

    validates_inclusion_of :gender, :in => %w( m f )
    validates :birthnumber, format: { with: /\A[0-9]+\z/, allow_blank: true}
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

    # strict validation only when using web interface
    validates_presence_of :occupation, :birthdate, :email,
                          :phone, :gender, :street, :city, :zipcode,
                          :emergency_name, :emergency_day, :birthnumber,
                          if: :strict_validation?

    include PhoneValidation
  end


  def name
    "#{lastname} #{firstname}"
  end

  def male?
    gender == Person::MALE
  end

  def female?
    gender == Person::FEMALE
  end

  # http://www.jonathansng.com/ruby-on-rails/calculate-age-in-rails-with-a-birthday/
  def age(today = nil)
    return '?' unless birthdate

    today ||= Date.today
    age = today.year - birthdate.year
    age -= 1 if birthdate > today.years_ago(age)
    age
  end

end
