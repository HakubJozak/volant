class FileAttachment < Attachment
  mount_uploader :file, AttachmentUploader

  def mime_type
    file.try(:content_type)
  end
  
  def has_data?
    !file.nil?
  end

  def data
    return nil unless file
    raw = file.read

    if file_identifier =~ /\.html\z/
      # HACK: we should analyze the correct encoding
      raw.force_encoding('UTF-8')
    else
      raw
    end
  end

  def filename
    file_identifier || 'untitled'
  end
end

# == Schema Information
#
# Table name: attachments
#
#  id            :integer          not null, primary key
#  file          :string(255)
#  type          :string(255)      default("Attachment"), not null
#  message_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  workcamp_id   :integer
#  apply_form_id :integer
#
