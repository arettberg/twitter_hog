require 'rails_helper'

RSpec.describe TwitterInterface, type: :module do
  describe 'caching' do
    it 'should cache results in redis' do
      first = TwitterInterface.redis_or('some search'){ 1 }
      second = TwitterInterface.redis_or('some search'){ 2 }
      expect(first).to eq(second)
    end
  end
end
