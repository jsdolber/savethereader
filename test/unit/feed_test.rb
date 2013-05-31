require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  
  test "don't save without mandatory fields" do
    feed = Feed.new
    assert !feed.save, "saved feed without mandatory fields"
  end

  test "save with mandatory fields" do
    feed = Feed.new(:title => "techcrunch", :url => "http://techcrunch.com")
    assert feed.save, "didn't save feed with mandatory fields"
  end

  test "feedzirra fetch and parse for multiple urls" do
    urls = Feed.all.map {|feed| feed.url }
    feeds = Feedzirra::Feed.fetch_and_parse(urls)

    assert urls.count == feeds.count, "not count from feeds url and feedzirra fetch"
  end

  test "feed update from feedzirra entry count match" do
    feed = Feedzirra::Feed.fetch_and_parse(feeds(:stackoverflow).url)
    feeds(:stackoverflow).update_feed_db(feed.sanitize_entries!)
    assert feed.entries.count == feeds(:stackoverflow).entries.count, "entry count didn't match"
  end

  test "feed duplicate url" do
    feed = Feed.new(:title => "stackoverflow", :url => "http://stackoverflow.com/feeds") # stack overflow should be defined in the fixtures
    assert !feed.save, "saved a duplicated feed"
  end

  test "create and update feed" do
    assert !Feed.create_and_update("http://reddit.com/r/videos").nil?, "feed is nil"
  end
  

end
