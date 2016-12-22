module TwitterInterface
  MAX_REQUESTED_TWEETS = 100
  REDIS_NAMESPACE = 'TwitterInterface'

  class << self
    include RedisWrap

    def recent_tweets_for_user username, count: 25
      count = MAX_REQUESTED_TWEETS if count > MAX_REQUESTED_TWEETS # no going over
      user = username.is_a?(Twitter::User) ? username : get_user(username)

      if user
        redis_or "tweets_for:#{user.screen_name}", ttl: 5.minutes do
          client.user_timeline user, count: count, response_type: :latest
        end
      end
    end

    def get_user username
      if username.present?
        username = username.downcase

        redis_or "user:#{username}", ttl: 5.minutes do
          client.user(username)
        end
      end
    rescue Twitter::Error::NotFound
      nil
    end

    def client
      @twitter_client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end
  end
end
