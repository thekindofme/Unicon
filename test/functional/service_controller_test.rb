require 'test_helper'

class ServiceControllerTest < ActionController::TestCase
  test "should get contacts" do
    get :contacts, 'username' =>"bjohnson", 'hash'=> Authlogic::CryptoProviders::Sha1.encrypt("benrocks" + "unicon")
    assert_response :success
  end
end
