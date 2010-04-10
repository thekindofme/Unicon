require 'test_helper'

class ContactSourceTest < ActiveSupport::TestCase

  def test_get_pre_sync_report_method_should_not_raise_any_exceptions
    cs = ContactSource.new
    cs.name = "CS with valid info"
    cs.username = "hwijesureeya"
    cs.password = "IGTF*S^&888sf"
    cs.user_id = 0 #assumming we have atleast one user added in the test db
    cs.provider = "gmail"

    assert_nothing_raised { cs.get_pre_sync_report }
  end

  def test_sync_method_should_not_raise_any_exceptions
    cs = ContactSource.new
    cs.name = "CS with valid info"
    cs.username = "hwijesureeya"
    cs.password = "IGTF*S^&888sf"
    cs.user_id = 0 #assumming we have atleast one user added in the test db
    cs.provider = "gmail"

    assert_nothing_raised { cs.sync }
  end

  def test_should_not_save_empty_contact_source
    cs = ContactSource.new
    assert !cs.save
  end

  def test_should_not_save_contact_source_without_name
    cs = ContactSource.new
    cs.username = "test username"
    cs.password = "test password"
    cs.user_id = 0 #assumming we have atleast one user added in the test db
    cs.provider = "gmail"
    assert !cs.save
  end

  def test_should_not_save_contact_source_without_username
    cs = ContactSource.new
    cs.name = "test name"
    cs.password = "test password"
    cs.user_id = 0 #assumming we have atleast one user added in the test db
    cs.provider = "gmail"
    assert !cs.save
  end

  def test_should_not_save_contact_source_without_passowrd
    cs = ContactSource.new
    cs.name = "test name"
    cs.username = "test username"
    cs.user_id = 0 #assumming we have atleast one user added in the test db
    cs.provider = "gmail"
    assert !cs.save
  end

  def test_should_not_save_contact_source_without_user
    cs = ContactSource.new
    cs.name = "test name"
    cs.username = "test username"
    cs.password = "test password"
    cs.provider = "gmail"
    assert !cs.save
  end

  def test_should_not_save_contact_source_without_provider
    cs = ContactSource.new
    cs.name = "test name"
    cs.username = "test username"
    cs.password = "test password"
    cs.user_id = 0 #assumming we have atleast one user added in the test db
    assert !cs.save
  end
end
