#reprecents a contact.
class Contact < ActiveRecord::Base
  belongs_to :contact_source #from which this originated, if any.
  belongs_to :user #who owns this

  #trac which contact sources have(though syncing) this contact
  has_many :contacts_synced_with_contact_sources
#  has_many :contact_sources, :source => "contact_source", :class_name => "ContactSource", :through => :contacts_synced_with_contact_sources
  has_many :contact_sources, :through => :contacts_synced_with_contact_sources

  #validation
  validates_presence_of :first_name, :email, :contact_source, :user

  #get all non deleted(deleted => false) contacts that belong to a user
  def self.all_contacts user_id
    find_all_by_user_id user_id, :conditions => {:deleted => false}
  end

  #get all non synced AND non deleted(deleted => false) contacts that belong to a user
  def self.contacts_to_be_exported user_id, contact_source
    result = []
    find_all_by_user_id(user_id, :conditions => {:deleted => false}).each do |contact|
      result << contact if !contact.contact_sources.include?(contact_source)
    end
    result
  end

  #get all including deleted(deleted => true) contacts that belong to a user
  def self.all_including_deleted user_id
    find_all_by_user_id user_id
  end

#  #get all synced AND deleted contacts
#  def self.to_be_remotly_deleted_contacts user_id, contact_source
#    result = []
#    find_all_by_user_id(user_id, :conditions => {:deleted => true}).each do |contact|
#      result << contact if contact.contact_sources.include? contact_source
#    end
#    result
#  end
#
#  #get all synced AND not deleted contacts
#  def self.synced_but_not_deleted_contacts user_id, contact_source
#    result = []
#    find_all_by_user_id(user_id, :conditions => {:deleted => false}).each do |contact|
#      result << contact if contact.contact_sources.include? contact_source
#    end
#    result
#  end

  def self.get_synced_contacts user_id, contact_source, include_deleted
    result = []
    find_all_by_user_id(user_id, :conditions => {:deleted => include_deleted}).each do |contact|
      result << contact if contact.contact_sources.include? contact_source
    end
    result
  end

  #delete a contact in 'sync safe way'
  #if the contact is a already synced one, it will not be deleted right away. its deleted will be set to true
  #so that when it's contact source is synced, its delete will be synced with the remote contact sources, and
  #then it will be deleted from unicon's systems
  #if the contact is not synced already it will be just deleted
  def sync_safe_delete
    if contact_sources.length != 0
      self.deleted = true
      save
    else
      delete_contact_with_its_cs_relations
    end
  end

  def delete_contact_with_its_cs_relations
    #delete any ContactsSyncedWithContactSource(wich reprecents relations between contacts and contact sources)
    #related to this Contact. before deleting this contact
    cswcs_to_be_delete = ContactsSyncedWithContactSource.all :conditions => {:contact_id =>self.id}
    cswcs_to_be_delete.each {|cswcs|
      cswcs.destroy
    }
    destroy
  end

  #return a hash that have keys, values that corosponds to properties and the respective values
  #    ex:-
  #    {
  #      :first_name => "jhon",
  #      :last_name => "baston",
  #      :emails => ["jbaston@yahoo.in"],
  #      :note => "some notes about jhon"
  #    }
  def get_contact_as_a_hash
    {
      :first_name => first_name,
      :last_name => last_name,
      :emails => [email],
      :note => note
    }
  end

  #a equals method to check whether a hash representing a contact is equal to a Contact object
  #pcontact - is a hash representing a contact, this might have been returned from a contact manager
  #such as GmailContactManager
  #    pcontact ex:-
  #    {
  #      :first_name => "jhon",
  #      :last_name => "baston",
  #      :emails => ["jbaston@yahoo.in", "jhon24ccountry@gmail.com"],
  #      :note => "some notes about jhon"
  #    }
  def is_a_equal_contact_as_a_hash? pcontact
    pcontact[:emails].each{|pcontact_email|
      return true if email == pcontact_email
    }
    false
  end

end
