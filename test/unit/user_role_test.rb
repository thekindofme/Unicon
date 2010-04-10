require 'test_helper'

class UserRoleTest < ActiveSupport::TestCase
  def test_should_not_save_empty_user_role
    ur = UserRole.new
    assert !ur.save
  end

  def test_should_not_save_user_role_without_user
    ur = UserRole.new
    ur.role_id = 0 #assuming role 0 is there
    assert !ur.save
  end

  def test_should_not_save_user_role_without_role
    ur = UserRole.new
    ur.user_id =0 #assuming user 0 is there
    assert !ur.save
  end
end
