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
