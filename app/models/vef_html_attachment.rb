class VefHtmlAttachment < VefAttachment
  belongs_to :apply_form
  validates_presence_of :apply_form

  def data
    Export::VefHtml.new(apply_form).to_html
  end

  def filename
    Export::VefHtml.new(apply_form).filename
  end
end
