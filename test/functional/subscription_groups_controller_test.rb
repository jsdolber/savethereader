require 'test_helper'

class SubscriptionGroupsControllerTest < ActionController::TestCase
  setup do
    @subscription_group = subscription_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subscription_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subscription_group" do
    assert_difference('SubscriptionGroup.count') do
      post :create, subscription_group: {  }
    end

    assert_redirected_to subscription_group_path(assigns(:subscription_group))
  end

  test "should show subscription_group" do
    get :show, id: @subscription_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subscription_group
    assert_response :success
  end

  test "should update subscription_group" do
    put :update, id: @subscription_group, subscription_group: {  }
    assert_redirected_to subscription_group_path(assigns(:subscription_group))
  end

  test "should destroy subscription_group" do
    assert_difference('SubscriptionGroup.count', -1) do
      delete :destroy, id: @subscription_group
    end

    assert_redirected_to subscription_groups_path
  end
end
