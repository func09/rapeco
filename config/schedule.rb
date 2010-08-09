set :output, "#{RAILS_ROOT}/log/cron.log"

every 2.minutes do
  runner 'Crawler.check_upload'
end
