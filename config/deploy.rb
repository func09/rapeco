set :rails_env, 'production'

set :application, "bimitter"
set :repository,  "http://svn.func09.net/bimitter/trunk/"

set :scm, :subversion
set :scm_username,    ENV['SVN_USER'] || ENV['USER']
set :scm_password, proc{Capistrano::CLI.password_prompt("Please input #{user} password for #{scm}:")}

set :user, 'app'
set :use_sudo, false
# set :ssh_options, :keys => './.ssh/app_deploy'
set :deploy_via, :export
set :deploy_to, "/home/#{user}/deploy/#{rails_env}_#{application}"

role :web, "func09.net"                          # Your HTTP server, Apache/etc
role :app, "func09.net"                          # This may be the same as your `Web` server
role :db,  "func09.net", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do
  end
  task :stop do
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  desc "Copy shared config files to current application."
  task :copy_config_file, :roles => :app do
    run <<-CMD
      for CONFIG in #{release_path}/config/*.yml.sample;
      do cp -f "$CONFIG" `echo "$CONFIG" | sed 's,\.sample$,,'`;
      done;
    CMD
  end
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --set environment=#{rails_env} --update-crontab #{application}_#{rails_env}"
  end
  
end

after 'deploy:update_code', 'deploy:copy_config_file'
after "deploy:symlink", "deploy:update_crontab"

after 'deploy:finalize_update' do
  # run "cd #{latest_release} && bundle install #{shared_path}/vendor --without development,test && bundle lock"
  run "cd #{latest_release} && bundle install #{shared_path}/vendor && bundle lock"
end
