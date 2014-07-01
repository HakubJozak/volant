module Incoming
  class Partner < ActiveRecord::Base

    acts_as_taggable

    has_many :hostings, :class_name => 'Incoming::Hosting'
    has_many :workcamps, :through => :hostings, :class_name => 'Incoming::Workcamp'

    def to_label
      name
    end
  end
end
