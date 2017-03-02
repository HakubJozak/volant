Factory.define :file_attachment do |a|
  a.file File.new("#{Rails.root}/test/fixtures/fpl/FPL.xml")
end
