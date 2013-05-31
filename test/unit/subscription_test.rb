require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  test "don't save without mandatory fields" do
    s = Subscription.new
    assert !s.save, "saved without mandatory fields"
  end

  test "save with mandatory fields" do
    s = Subscription.create(:feed_id => feeds(:stackoverflow), :user_id => users(:user1))
    assert s, "couldn't save with mandatory fields"
  end

  test "init in nil for invalid url subscription" do
    assert !Subscription.init("invalidurl.com/invalid", nil, users(:user1).id).valid?, "subscription is valid"
  end

  test "init is valid for invalid group subscription" do
    assert Subscription.init("reddit.com/r/music", "NONEXISTENT", users(:user1).id).valid?, "subscription is invalid"
  end

  test "unread count" do
    s = Subscription.init("stackoverflow.com", nil, users(:user1).id)
    s.save!
    assert_equal(s.unread_count, feeds(:stackoverflow).entries.where('created_at > ?', s.created_at - 12.hours).count, "count does not match") 
  end

end
