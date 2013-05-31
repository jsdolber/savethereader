require 'test_helper'

class SubscriptionGroupTest < ActiveSupport::TestCase

  test "don't save without mandatory fields" do
    grp = SubscriptionGroup.new
    assert !grp.save, "saved without mandatory fields"
  end

  test "save with mandatory fields" do
    grp = SubscriptionGroup.new :name => "TECH"
    grp.user_id = users(:user1).id
    assert grp.save, "didn't save with mandatory fields"
  end

  test "name within bounds" do
    grp = SubscriptionGroup.new :name => "TECH12345678901234567890"
    grp.user_id = users(:user1).id
    assert !grp.save, "created group with name with char length > 20"
  end

  test "no duplicate names" do
    grp = SubscriptionGroup.new :name => "TECH"
    grp.user_id = users(:user1).id
    grp.save!
    grp = SubscriptionGroup.new :name => "TECH"
    grp.user_id = users(:user1).id
    assert !grp.save, "created group with duplicate name"
  end
end
