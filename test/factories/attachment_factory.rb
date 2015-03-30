Factory.define :file_attachment do |a|
  a.file File.new("#{Rails.root}/test/fixtures/xml/FPL.xml")
end
