class Incoming::Hosting < ActiveRecord::Base
  validates_presence_of :partner, :workcamp

  belongs_to :workcamp, :class_name => 'Incoming::Workcamp'
  belongs_to :partner, :class_name => 'Incoming::Partner'

  def to_label
    self.partner.to_label
  end
end
