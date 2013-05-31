require 'test_helper'

class ReadentryTest < ActiveSupport::TestCase
  test "don't save without mandatory fields" do
    r = Readentry.new
    assert !r.save, "saved without mandatory fields"
  end

  test "save with mandatory fields" do
    r = Readentry.new :entry_id => 99, :subscription_id => 1 
    r.user_id = users(:user1).id
    assert r.save, "didn't save with mandatory fields"
  end

  test "don't save duplicate entries" do
    r = Readentry.new :entry_id => 99, :subscription_id => 1 
    r.user_id = users(:user1).id
    r.save!
    r = Readentry.new :entry_id => 99, :subscription_id => 1 
    r.user_id = users(:user1).id
    assert !r.save, "saved duplicate entry"
  end
end
