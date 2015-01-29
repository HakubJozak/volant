class InfosheetAttachment < Attachment
  belongs_to :workcamp
  validates_presence_of :workcamp

  def has_data?
    raise NotImplemented
  end

  def data
    raise NotImplemented
  end

  def filename
    raise NotImplemented
  end  
end
