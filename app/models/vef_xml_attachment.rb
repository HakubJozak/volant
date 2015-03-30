class VefXmlAttachment < Attachment
  belongs_to :apply_form
  validates_presence_of :apply_form

  def mime_type
    'text/xml'
  end

  def has_data?
    true
  end

  def data
    Export::VefXml.new(apply_form).to_xml
  end

  def filename
    Export::VefXml.new(apply_form).filename
  end
end
