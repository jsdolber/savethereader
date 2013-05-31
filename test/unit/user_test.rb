require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "don't save without mandatory fields" do
    user = User.new
    assert !user.save, "saved user without mandatory fields"
  end

  test "save with mandatory fields" do
    user = User.create(:email => "hello@email.com", :password => "1234", :password_confirmation => "1234")
    assert user, "couldn't save user with mandatory fields"
  end

  test "don't save with duplicate email" do
    user = User.new(:email => users(:user1).email, :password => "1234", :password_confirmation => "1234")
    assert !user.save, "created user with duplicate email"
  end

end
