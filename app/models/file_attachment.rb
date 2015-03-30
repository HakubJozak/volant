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
