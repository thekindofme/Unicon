require 'test_helper'

class ContactSourcesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contact_sources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact_source" do
    assert_difference('ContactSource.count') do
      post :create, :contact_source => { }
    end

    assert_redirected_to contact_source_path(assigns(:contact_source))
  end

  test "should show contact_source" do
    get :show, :id => contact_sources(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => contact_sources(:one).id
    assert_response :success
  end

  test "should update contact_source" do
    put :update, :id => contact_sources(:one).id, :contact_source => { }
    assert_redirected_to contact_source_path(assigns(:contact_source))
  end

  test "should destroy contact_source" do
    assert_difference('ContactSource.count', -1) do
      delete :destroy, :id => contact_sources(:one).id
    end

    assert_redirected_to contact_sources_path
  end
end
