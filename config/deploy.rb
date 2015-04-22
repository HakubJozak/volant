require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/puma'

set :repository, 'git@github.com:HakubJozak/volant.git'


task :production do
  set :branch, 'incoming'
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

  if rails_env == 'staging'
    queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"]
    queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"]
  end

  queue! "sudo apt-get install -y wkhtmltopdf xvfb"
  queue! %[echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' | sudo tee --append /usr/local/bin/wkhtmltopdf]
  queue! "sudo chmod +x /usr/local/bin/wkhtmltopdf"
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
        invoke :'puma:restart'
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

namespace :log do
  task :app do
    queue! "tail -f #{deploy_to}/#{shared_path}/log/#{rails_env}.log"
  end

  task :unicorn do
    queue! "tail -f #{deploy_to}/#{shared_path}/log/unicorn.log"
  end

  task :nginx do
    queue! "sudo tail -f /var/log/nginx/#{appname}-error.log"
  end
end
