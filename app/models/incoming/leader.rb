module Incoming
  class Leader < ::Person
    has_many :leaderships, :class_name => 'Incoming::Leadership', :foreign_key => 'person_id'
    has_many :workcamps, :through => :leaderships, :class_name => 'Incoming::Workcamp', :source => :workcamp
  end
end
