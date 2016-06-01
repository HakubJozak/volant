class Person < ActiveRecord::Base
  MALE = 'm'
  FEMALE = 'f'

  include PersonalMethods

  scope :query, lambda { |query|
    columns = [ :firstname,:lastname,:email,:birthnumber,
                :phone,:passport_number].map { |attr|
      "#{table_name}.#{attr}"
    }
    fuzzy_like(*[query,columns].flatten)
  }

  acts_as_taggable

end
