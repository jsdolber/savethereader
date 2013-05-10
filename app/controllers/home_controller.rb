class HomeController < ApplicationController
  def index
    @feeds = Feedzirra::Feed.fetch_and_parse("http://stackoverflow.com/feeds")
    @feeds.sanitize_entries!
  end
end
