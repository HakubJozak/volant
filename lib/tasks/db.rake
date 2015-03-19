namespace :db do
  namespace :data do
    task :load do
      system 'gzip -d -v db/dump.sql.gz'
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke 
      system 'cat db/dump.sql | psql -d volant_development'
    end
  end
end
