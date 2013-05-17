require 'test_helper'

class ReadentriesControllerTest < ActionController::TestCase
  setup do
    @readentry = readentries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:readentries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create readentry" do
    assert_difference('Readentry.count') do
      post :create, readentry: {  }
    end

    assert_redirected_to readentry_path(assigns(:readentry))
  end

  test "should show readentry" do
    get :show, id: @readentry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @readentry
    assert_response :success
  end

  test "should update readentry" do
    put :update, id: @readentry, readentry: {  }
    assert_redirected_to readentry_path(assigns(:readentry))
  end

  test "should destroy readentry" do
    assert_difference('Readentry.count', -1) do
      delete :destroy, id: @readentry
    end

    assert_redirected_to readentries_path
  end
end
