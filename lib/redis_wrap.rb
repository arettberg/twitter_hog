module RedisWrap
  REDISTOGO_URL = ENV['REDISTOGO_URL']
  REDIS_HOST_URI = ENV['REDIS_HOST_URI']
  REDIS_PORT = ENV['REDIS_PORT']
  REDIS_DATABASE = 1
  REDIS_DEFAULT_TTL = 1.minute

  def redis_or key, ttl: REDIS_DEFAULT_TTL, cached: true, &block
    if redis.nil?
      puts 'Warning: cannot establish redis connection!'
      return block_given? ? yield : self.send(key)
    end

    if !cached || !(value = redis.get("#{redis_namespace}:#{key}"))
      (block_given? ? yield : self.send(key)).tap do |value|
        if value.present?
          yaml = value.try(:to_yaml)
          redis.set "#{redis_namespace}:#{key}", yaml, ex: ttl unless yaml.nil?
        end
      end
    else
      # puts "#{redis_id(key)} read from redis..." if Rails.env.development?
      YAML.load(value)
    end
  end

  def redis_namespace
    # looks up REDIS_NAMESPACE in the extending context, not here
    "#{self.name}::REDIS_NAMESPACE".safe_constantize || 'RedisWrap'
  end

  def redis
    @redis ||= if REDISTOGO_URL.present?
      url = URI.parse ENV['REDISTOGO_URL']
      Redis.new(host: url.host, port: url.port, password: url.password)
    else
      Redis.new(host: REDIS_HOST_URI, port: REDIS_PORT, db: REDIS_DATABASE)
    end
  end
end
