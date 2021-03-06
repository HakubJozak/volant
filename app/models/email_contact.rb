class EmailContact < ActiveRecord::Base
  validates_presence_of :address, :organization_id
  validates_inclusion_of :kind, :in => ['OUTGOING','INCOMING','LTV'], allow_blank: true
  belongs_to :organization

  scope :outgoing, lambda { where(kind: 'OUTGOING') }
  scope :incoming, lambda { where(kind: 'INCOMING') }
  scope :ltv, lambda { where(kind: 'LTV') }

end

# == Schema Information
#
# Table name: email_contacts
#
#  id              :integer          not null, primary key
#  active          :boolean          default(FALSE)
#  address         :string(255)      not null
#  name            :string(255)
#  notes           :string(255)
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  kind            :string(255)
#
