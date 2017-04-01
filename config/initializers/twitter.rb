require 'prime'
require 'net/http'

CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['consumer_key']
  config.consumer_secret = ENV['consumer_secret']
  config.access_token = ENV['access_token']
  config.access_token_secret = ENV['access_secret']
end

# monitor the time, tweet when appropriate
Thread.new do
  last_num = -1
  while true
    sleep 30
    time = Time.now
    time_num = time.strftime("%H%M").to_i
    # tweet if the current time is a prime number
    if time_num != last_num && Prime.prime?(time_num)
      CLIENT.update("The current time is #{time.strftime('%H:%M')}.\nIT'S PRIME TIME.")
      Rails.logger.info("Tweeting at #{time.to_s}")
      last_num = time_num
    end
  end
end

# ping the production server every 30 minutes to prevent it from going to sleep
Thread.new do
  while true
    sleep 1800
    Net::HTTP.get("immense-falls-34635.herokuapp.com", "/")
  end
end
