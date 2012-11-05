File.open("#{RAILS_ROOT}/db/languages.csv").each_line do |lang|
  l = lang.split(',').map { |word| word.strip }
  Language.create!(:code => l[0], :triple_code => l[1], :name_cs => l[2], :name_en => l[3])
end
