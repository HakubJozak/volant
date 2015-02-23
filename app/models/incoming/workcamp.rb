require 'digest'

class Incoming::Workcamp < ::Workcamp
  default_scope -> { order 'begin' }

  has_many :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::WorkcampAssignment'
  has_many :apply_forms, through: :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::ApplyForm'

  has_many :bookings, :class_name => 'Incoming::Booking'
  has_many :participants, :class_name => 'Incoming::Participant', :dependent => :nullify

  validates :begin, presence: true
  validates :end, presence: true
#   validates :project_id, uniqueness: true

  after_validation do
    # generate_project_id
    self.project_id ||= begin
                          md5 = Digest::MD5.new
                          md5 << name
                          md5 << code
                          md5 << self.begin.to_s
                          md5 << self.end.to_s
                          md5.hexdigest
                        end
  end


  def free_places
    capacity - participants.not_cancelled.count - bookings.count
  end

  def free_places_for_males
    [ free_places, capacity_males - bookings.males.count - participants.males.not_cancelled.count ].min
  end

  def free_places_for_females
    [ free_places, capacity_females - bookings.females.count - participants.females.not_cancelled.count ].min
  end

  # TODO - specify dates
  def self.free
    all.select { |wc| wc.free_places > 0 }
  end

  # return comma separated string listing nationalities which
  # are not allowed for this workcamp any more
  def no_more_nationalities
    nations = participants.not_cancelled.map { |p| p.nationality.to_s.downcase.strip }
    nations.uniq.select { |x| nations.count(x) > 1}.map { |n| n.capitalize }
  end

  protected

  # avoid nils
  [ '', '_males', '_females' ].each do |sufix|
    attr = "capacity#{sufix}"
    define_method(attr) do
      read_attribute(attr) || read_attribute('capacity') || 0
    end
  end


end
