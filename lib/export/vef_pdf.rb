class Export::VefPdf < Export::VefHtml
  
  def sufix
    'pdf'
  end
  
  def data
    PDFKit.new(super, :page_size => 'Letter').to_pdf
  end

  alias :to_pdf :data
end
