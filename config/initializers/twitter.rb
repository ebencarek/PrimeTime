require 'prime'

CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['consumer_key']
  config.consumer_secret = ENV['consumer_secret']
  config.access_token = ENV['access_token']
  config.access_token_secret = ENV['access_secret']
end

Thread.new do
  while true
    # only run once per minute, won't check seconds of the time
    sleep 60
    time = Time.now
    time_num = time.strftime("%H%M").to_i
    # tweet if the current time is a prime number
    if Prime.prime?(time_num)
      CLIENT.update("The current time is #{time.strftime('%H:%M')}.\nIT'S PRIME TIME.")
      Rails.logger.info("Tweeting at #{time.to_s}")
    end
  end
end
