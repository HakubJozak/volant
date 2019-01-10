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
  	task import_vocatives: :environment do
  		data = SmarterCSV.process( './db/vocatives/krestni_muzi.csv', :headers_in_file => false, user_provided_headers: %i[freq n v], )

  		bar = ProgressBar.create(:title => "Import vocatives", :total => data.count)
	    data.each do |d|
    	  v = Vocative.new
	      v.type = 'f'
	      v.gender = 'm'
	      v.nominative = d[:n]
	      v.vocative =  d[:v]
	      v.save(validate: false)
	      bar.increment
	    end
  	end
  end
end
