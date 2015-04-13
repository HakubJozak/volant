class EmailContact < ActiveRecord::Base
  validates_presence_of :address, :organization_id
  validates_inclusion_of :kind, :in => ['OUTGOING','INCOMING','LTV'], allow_blank: true
  belongs_to :organization

  scope :outgoing, lambda { where(kind: 'OUTGOING') }
  scope :incoming, lambda { where(kind: 'INCOMING') }
  scope :ltv, lambda { where(kind: 'LTV') }

end
