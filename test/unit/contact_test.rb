require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  def test_all_contacts_method
    contact = Contact.new
    contact.first_name = "test first name"
    contact.email = "test@email.com"
    contact.contact_source_id = 0 #assumming at least one contact source is added to the test db
    contact.user_id = 0 #assumming at least one user is added to the test db
    
    contact.save
    assert Contact.all_contacts(0).size > 0
  end

  def test_all_including_deleted_method
    contact = Contact.new
    contact.first_name = "test first name"
    contact.email = "test@email.com"
    contact.contact_source_id = 0 #assumming at least one contact source is added to the test db
    contact.user_id = 0 #assumming at least one user is added to the test db
    contact.deleted = true
    contact.save
    assert Contact.all_including_deleted(0).size > 0
  end

  def test_should_not_save_empty_contact
    contact = Contact.new
    assert !contact.save
  end

  def test_should_not_save_contact_without_first_name
    contact = Contact.new
    contact.email = "test@email.com"
    contact.contact_source_id = 0 #assumming at least one contact source is added to the test db
    contact.user_id = 0 #assumming at least one user is added to the test db
    assert !contact.save
  end

  def test_should_not_save_contact_without_email
    contact = Contact.new
    contact.first_name = "test first name"
    contact.contact_source_id = 0 #assumming at least one contact source is added to the test db
    contact.user_id = 0 #assumming at least one user is added to the test db
    assert !contact.save
  end

  def test_should_not_save_contact_without_contact_source
    contact = Contact.new
    contact.first_name = "test first name"
    contact.email = "test@email.com"
    contact.user_id = 0 #assumming at least one user is added to the test db
    assert !contact.save
  end

  def test_should_not_save_contact_without_user
    contact = Contact.new
    contact.first_name = "test first name"
    contact.email = "test@email.com"
    contact.contact_source_id = 0 #assumming at least one contact source is added to the test db
    assert !contact.save
  end
end
