class Person < ActiveRecord::Base
  MALE = 'm'
  FEMALE = 'f'

  include PersonalMethods
  
  acts_as_taggable

end
