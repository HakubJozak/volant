class Attachment < ActiveRecord::Base
  belongs_to :message
  mount_uploader :file, AttachmentUploader

  def has_data?
    file != nil
  end

  def data
    file.read if file
  end

  def filename
    file_identifier || 'untitled'
  end
end
