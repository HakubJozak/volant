class VefPdfAttachment < Attachment
  belongs_to :apply_form
  validates_presence_of :apply_form

  def has_data?
    true
  end
  
  def mime_type
    'application/pdf'
  end

  def data
    Export::VefPdf.new(apply_form).to_pdf
  end

  def filename
    Export::VefPdf.new(apply_form).filename
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
