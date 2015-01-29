class VefAttachment < Attachment
  belongs_to :apply_form
  validates_presence_of :apply_form

  def has_data?
    file != nil
  end

  def data
    Export::VefXml.new(apply_form).to_xml
  end

  def filename
    Export::VefXml.new(apply_form).filename
  end
end
