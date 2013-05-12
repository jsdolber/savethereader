class HomeController < ApplicationController
  def index
    @feeds = Feedzirra::Feed.fetch_and_parse("http://stackoverflow.com/feeds")
    @feeds.sanitize_entries!
    #user = current_user
    @groups = SubscriptionGroup.find(:all)
  end
end
