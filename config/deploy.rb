require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'


set :repository, 'git@github.com:HakubJozak/volant.git'
set :user, 'rails'
set :branch, 'master'

task :staging do
  set :deploy_to, '/home/rails/volant-staging'
  set :domain, 'pelican.amagical.net'
end

task :production do
  set :deploy_to, '/home/rails/volant'
  set :domain, 'pelican.amagical.net'
end



set :shared_paths, ['config/database.yml', 'config/secrets.yml','log','public/uploads']



set :forward_agent, true

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/uploads"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => [ :environment ]do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

namespace :db do
  task :dump do
    # ssh volant@bolen ...
    # system "pg_dump -F p volant_production | gzip > now.sql.gz"
  end
end



task :restart => [ :environment ] do
  puts 'Restarting...'
  queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
end

# Stopping
# cd /etc/apache2/
# ln -s sites-available/volant sites-enabled/001-volant
