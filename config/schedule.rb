# set :output, "#{::Rails.root}/log/cron.log"

every 2.minutes do
  runner 'Crawler.exec'
end

every 1.day, :at => '4:30 am' do
  rake "backup:run trigger='mysql-backup-s3'"
end
