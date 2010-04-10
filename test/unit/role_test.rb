require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  def test_should_not_save_empty_role
    role = Role.new
    assert !role.save
  end
end
