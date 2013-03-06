set :application, "volant"
server "bolen.onesim.net", :app, :web, :db, :primary => true

set :scm, "git"
set :repository,  "git://github.com/simi/volant.git"
set :keep_releases, 2
set :user, "volant"
set :use_sudo, false
set :git_enable_submodules, true

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
    [ 'database.yml', 'volant.rb' ].each do |name|
      run "ln -nfs #{shared_path}/config/#{name} #{release_path}/config/#{name}"
    end
  end

  desc "Restart Application"
   task :restart, :roles => :app do
    run "rm #{current_path}/Gemfile.lock"
    run "touch #{current_path}/tmp/restart.txt"
   end

end

