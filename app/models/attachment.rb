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


# class InfosheetAttachment < Attachment
#   belongs_to :workcamp
#   validates_presence_of :workcamp

#   def has_data?
#     file != nil
#   end

#   def data
#     '<vef></vef>'
#   end

#   def filename
#     'vef.xml'
#   end  
# end
