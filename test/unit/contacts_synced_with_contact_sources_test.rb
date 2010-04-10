require 'test_helper'

class ContactsSyncedWithContactSourcesTest < ActiveSupport::TestCase
  def test_should_not_save_empty_object
    obj = ContactsSyncedWithContactSource.new
    assert !obj.save
  end

  def test_should_not_save_without_contact
    obj = ContactsSyncedWithContactSource.new
    obj.contact_source_id = 0 #assumming contact source 0 exists
    assert !obj.save
  end

  def test_should_not_save_without_contact_source
    obj = ContactsSyncedWithContactSource.new
    obj.contact_id = 0 #assumming contact 0 exists
    assert !obj.save
  end

end
