require 'rails_helper'

RSpec.describe TwitterInterface, type: :module do
  describe 'user lookup' do
    it 'should return nil if username is blank' do
      expect(TwitterInterface.get_user('')).to be_nil
    end
  end
end
