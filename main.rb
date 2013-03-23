require 'sinatra'

require 'redis'
require 'json'

get '/' do
  erb :index
end

get '/inbox_count' do
  redis = Redis.new

  counts = redis.sort('timestamps', :get => ['#', 'counts/stamp:*->total'], :limit => [-40, -1])
  counts_as_hash = Hash[*counts.flatten]

  content_type :json
  return counts_as_hash.to_json
end
