require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_user_add_role
    u = User.all[0] #assuming that user 0 is there
    role = Role.all[0] #assuming that role 0 is there
    assert_nothing_raised { u.add_role(role) }
  end

  def test_user_has_role?
    u = User.all[0] #assuming that user 0 is there
    role = Role.all[0] #assuming that role 0 is there
    assert u.has_role?(role)
  end
end
