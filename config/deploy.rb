require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/puma'

set :repository, 'git@github.com:HakubJozak/volant.git'


task :production do
  set :branch, 'master'
  set :user, 'rails'
  set :deploy_to, '/home/rails/volant'
  set :domain, 'pelican.amagical.net'
  set :rails_env, 'production'
end


task :staging do
  set :branch, 'incoming'
  set :user, 'jakub'
  set :deploy_to, '/home/jakub/volant'
  set :domain, '128.199.36.58'
  set :rails_env, 'staging'
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
      if rails_env == 'staging'
        invoke :'puma:start'
      else
        queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
        queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      end
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
  if rails_env == 'staging'
    invoke :'puma:start'
  else
    queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
  end
end

# Stopping
# cd /etc/apache2/
# ln -s sites-available/volant sites-enabled/001-volant
