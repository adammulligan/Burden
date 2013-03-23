require 'redis'
require 'gmail'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

def retrieve_and_store_inbox_count
  timestamp = Time.now.to_i

  gmail = Gmail.new('', '')
  count = gmail.inbox.count

  redis = Redis.new
  redis.sadd('timestamps', timestamp)
  redis.hincrby("counts/stamp:#{timestamp}", "total", count)

  puts "Added #{count} emails at #{timestamp}"
end

retrieve_and_store_inbox_count
scheduler.every '5m' do
  retrieve_and_store_inbox_count
end

scheduler.join
