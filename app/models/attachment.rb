class Attachment < ActiveRecord::Base
  belongs_to :message
  validates_presence_of :message
  mount_uploader :file, AttachmentUploader
end
