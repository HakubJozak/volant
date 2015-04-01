module PersonalMethods
  def name
    "#{lastname} #{firstname}"
  end

  def male?
    gender == Person::MALE
  end

  def female?
    not male?
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
