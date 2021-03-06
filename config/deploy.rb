set :rails_env, :production
set :repository,  'git://github.com/func09/rapeco.git'
set :application, "rapeco"

set :scm, :git
set :user, "app"
set :use_sudo, false
set :branch, "release"
set :deploy_via, :copy
set :deploy_to, "/home/app/deploy/#{application}"

role :web, "rapeco.jp"
role :app, "rapeco.jp"
role :db,  "rapeco.jp", :primary => true

set :unicorn_binary, "bundle exec unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do

  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

=begin
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill `cat #{unicorn_pid}` || echo 'no pid file'"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}` || echo 'no pid file'"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}` || echo 'no pid file'"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    reload
  end
=end
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
    run "cd #{release_path} && bundle exec whenever --set environment=#{rails_env} --update-crontab #{application}_#{rails_env}"
  end
  
end

namespace :deploy do
  namespace :web do
    desc 'Upload Maintenance HTML'
    task :disable, :roles => :web do
      # invoke with  
      # UNTIL="16:00 MST" REASON="a database upgrade" cap deploy:web:disable

      on_rollback { rm "#{shared_path}/system/maintenance.html" }

      require 'erb'
      deadline, reason = ENV['UNTIL'], ENV['REASON']
      maintenance = ERB.new(File.read("./app/views/layouts/maintenance.html.erb")).result(binding)

      put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
end

after 'deploy:update_code', 'deploy:copy_config_file'
after "deploy:symlink", "deploy:update_crontab"

after 'deploy:finalize_update' do
  run "cd #{latest_release} && bundle install #{shared_path}/vendor --without development,test"
end
