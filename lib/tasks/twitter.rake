require 'prime'

namespace :primetime do
  desc "Create twitter client, continuously check time and tweet when time is a prime number."
  task twitter: :environment do

    CLIENT = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['consumer_key']
      config.consumer_secret = ENV['consumer_secret']
      config.access_token = ENV['access_token']
      config.access_token_secret = ENV['access_secret']
    end
    
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
end
