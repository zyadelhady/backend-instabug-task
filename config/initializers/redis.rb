require 'redis'
REDIS = Redis.new(host: "redis", port: 6379, db: 11)
