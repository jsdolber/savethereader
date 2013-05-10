require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  
  test "don't save without mandatory fields" do
    feed = Feed.new
    assert !feed.save, "don't save feed without mandatory fields"
  end

  test "save with mandatory fields" do
    feed = Feed.new(:title => "hello", :url => "http://url.com.feed", :user_id => users(:user1).id)
    assert feed.save, "save feed with mandatory fields"
  end

end
