class Attachment < ActiveRecord::Base
  belongs_to :message
  mount_uploader :file, AttachmentUploader
end

class VefAttachment < Attachment
  belongs_to :apply_form
end

class InfosheetAttachment < Attachment
  belongs_to :workcamp
end
