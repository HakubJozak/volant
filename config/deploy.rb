set :application, "volant"
server "bolen.onesim.net", :app, :web, :db, :primary => true

set :scm, "git"
set :repository,  "git@bolen.onesim.net:volant.git"
set :keep_releases, 2
set :user, "volant"
set :use_sudo, false

after "deploy:update_code", "deploy:symlink_shared"


task :demo do
  set :branch, "master"
  set :deploy_to, "/home/volant/demo"
end

task :live do
  set :branch, "master"
  set :deploy_to, "/home/volant/app"
end


namespace :deploy do
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Restart Application"
   task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
   end

end

