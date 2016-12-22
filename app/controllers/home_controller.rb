class HomeController < ApplicationController
  def index
    @twitter_username = params[:username]
    @twitter_user = TwitterInterface.get_user @twitter_username

    if @twitter_user
      @tweets = TwitterInterface.recent_tweets_for_user(@twitter_user)
    end
  end
end
