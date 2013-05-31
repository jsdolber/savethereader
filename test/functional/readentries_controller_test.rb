require 'test_helper'

class ReadentriesControllerTest < ActionController::TestCase
  setup do
    @readentry = readentries(:one)
  end

  test "should create readentry" do
    #assert_difference('Readentry.count') do
    #  post :create, readentry: { :entry_id => 1, :subscription_id => 1 }
    #end

    #assert_redirected_to readentry_path(assigns(:readentry))
  end

  test "should show readentry" do
    #get :show, id: @readentry
    #assert_response :success
  end

end
