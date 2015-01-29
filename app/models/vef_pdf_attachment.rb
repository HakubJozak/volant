class VefPdfAttachment < Attachment
  belongs_to :apply_form
  validates_presence_of :apply_form

  def data
    Export::VefPdf.new(apply_form).to_pdf
  end

  def filename
    Export::VefPdf.new(apply_form).filename
  end
end
