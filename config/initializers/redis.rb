require 'redis'

REDIS = Redis.new(host: "redis", port: 6379, db: 11)
$red_lock = Redlock::Client.new([ENV["REDIS_URL"]])
