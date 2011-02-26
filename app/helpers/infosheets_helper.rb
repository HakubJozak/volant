module InfosheetsHelper
  
  def thumb_column(infosheet)
    doc = infosheet.document
    path = doc.path(:thumb)
    
    if path and File.exist?(path)
      image_tag( doc.url(:thumb), :class => 'thumb')
    else
      "No thumbnail"
    end
  end

end
