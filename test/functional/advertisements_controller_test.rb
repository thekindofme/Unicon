require 'test_helper'

class AdvertisementsControllerTest < ActionController::TestCase
  test "should get index" do
    set_session_for(users(:admin))
    get :index
    assert_response :success
    assert_not_nil assigns(:advertisements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advertisement" do
    assert_difference('Advertisement.count') do
      post :create, :advertisement => { }
    end

    assert_redirected_to advertisement_path(assigns(:advertisement))
  end

  test "should show advertisement" do
    set_session_for(users(:admin))
    get :show, :id => advertisements(:one).id
    assert_response :success
  end

  test "should get edit" do
    set_session_for(users(:admin))
    get :edit, :id => advertisements(:one).id
    assert_response :success
  end

  test "should update advertisement" do
    set_session_for(users(:admin))
    put :update, :id => advertisements(:one).id, :advertisement => { }
    assert_redirected_to advertisement_path(assigns(:advertisement))
  end

  test "should destroy advertisement" do
    set_session_for(users(:admin))
    assert_difference('Advertisement.count', -1) do
      delete :destroy, :id => advertisements(:one).id
    end

    assert_redirected_to advertisements_path
  end
end
