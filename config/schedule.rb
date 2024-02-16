env :GEM_HOME, ENV['GEM_HOME']
set :environment, "development"
set :output, "log/cron.log"
set :bundle_command, 'bundle exec'

every :hour do
  runner "SyncChatsCount.sync_now"
  runner "SyncMessagesCount.sync_now"
end
