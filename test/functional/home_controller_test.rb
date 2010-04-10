require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:is_home)
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

  test "should get watch_demo" do
    get :watch_demo
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end
end
