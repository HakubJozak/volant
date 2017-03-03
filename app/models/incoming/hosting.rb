class Incoming::Hosting < ActiveRecord::Base
  validates_presence_of :partner, :workcamp

  belongs_to :workcamp, :class_name => 'Incoming::Workcamp'
  belongs_to :partner, :class_name => 'Incoming::Partner'

  def to_label
    self.partner.to_label
  end
end

# == Schema Information
#
# Table name: hostings
#
#  id          :integer          not null, primary key
#  workcamp_id :integer
#  partner_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#
