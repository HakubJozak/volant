require 'digest'

class Incoming::Workcamp < ::Outgoing::Workcamp
  has_many :participants,
           class_name: 'Incoming::Participant',
           dependent: :nullify

#   validates :project_id, uniqueness: true
  
  before_save do
    # generate_project_id
    self.project_id ||= begin
                          md5 = Digest::MD5.new
                          md5 << self.name
                          md5 << self.code
                          md5 << self.begin.to_s
                          md5 << self.end.to_s
                          md5.hexdigest
                        end
  end

end
