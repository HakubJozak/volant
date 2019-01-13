namespace :db do
  namespace :data do
    task :load do
      system 'gzip -d -v db/dump.sql.gz'
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      system 'cat db/dump.sql | psql -d volant_development'
    end
  end

  desc "Import data about czech vocatives for firstnames and surnames"
  namespace :import do
    task vocatives: :environment do
      # @fontan - cokoliv v Ruby zacina velkym pismenem, je konstanta
      # tady to nevadi, ale jinak dava zridka smysl ji definovat v
      # runtimu. Lokalni promenna je lepsi.
      #
      # ImportDef = [
      import_files = [
  	{ desc: "Krestni jmena - muzi",file: "krestni_muzi.csv",gender: "m",name_type: "f"},
  	{ desc: "Krestni jmena - zeny",file: "krestni_zeny.csv",gender: "f",name_type: "f"},
  	{ desc: "Prijmeni - muzi",file: "prijmeni_muzi_1.csv",gender: "m",name_type: "s"},
  	{ desc: "Prijmeni (ridka) - muzi",file: "prijmeni_muzi_2.csv",gender: "m",name_type: "s"},
  	{ desc: "Prijmeni - zeny",file: "prijmeni_zeny_1.csv",gender: "f",name_type: "s"},
  	{ desc: "Prijmeni (ridka) - zeny",file: "prijmeni_zeny_2.csv",gender: "f",name_type: "s"},
      ]

      import_files.each do |i|
	data = SmarterCSV.process( "./db/vocatives/#{i[:file]}", :headers_in_file => false, user_provided_headers: %i[freq n v], )

	bar = ProgressBar.create(:title => i[:desc], :total => data.count)
	data.each do |d|
	  v = Vocative.new
	  v.name_type = i[:type]
	  v.gender = i[:gender]
	  v.nominative = d[:n].downcase
	  v.vocative =  d[:v]
	  v.save(validate: false)
	  bar.increment
	end
      end
    end
  end
end
