require 'rails_helper'

RSpec.describe RedisWrap, type: :module do
  before do
    module FakeModule
      extend RedisWrap
      redis.flushall
    end
  end

  describe 'caching' do
    it 'should cache results in redis' do
      first = FakeModule.redis_or('some search'){ 1 }
      second = FakeModule.redis_or('some search'){ 2 }
      expect(first).to eq(second)
    end

    it 'should refresh after ttl timeout' do
      RedisWrap::REDIS_DEFAULT_TTL = 1.seconds
      first = FakeModule.redis_or('some search'){ 1 }

      sleep RedisWrap::REDIS_DEFAULT_TTL

      second = FakeModule.redis_or('some search'){ 2 }
      expect(first).to_not eq(second)
    end
  end
end
