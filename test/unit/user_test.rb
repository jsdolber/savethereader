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

end
