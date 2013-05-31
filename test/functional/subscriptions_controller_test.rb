require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase
  setup do
    @subscription = subscriptions(:one)
  end

  test "should create subscription" do
    #assert_difference('Subscription.count') do
    #  post :create, subscription: {  }
    #end

    #assert_redirected_to subscription_path(assigns(:subscription))
  end

  test "should show subscription" do
    #get :show, id: @subscription
    #assert_response :success
  end
  
  test "should destroy subscription" do
    #assert_difference('Subscription.count', -1) do
    #  delete :destroy, id: @subscription
    #end

    #assert_redirected_to subscriptions_path
  end
end
