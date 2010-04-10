require "contact_managers/gmail_contact_manager"
require "contact_managers/twitter_contact_manager"

#defines a contact source. this manages syncing of the contacts that belongs to it.
class ContactSource < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :username, :password, :user, :provider

  #sync all the contacts in this contact source with a remote contact provider(gmail, yahoo...etc)
  #will return a hash containing infomation on how the sync went
  def sync
    {
      :deleted_localy => sync_remote_deletes_with_local_contacts(false),
      :deleted_remotly => sync_local_deletes_with_remote_contacts(false),
      :imported => import_contacts,
      :exported => export_contacts
    }
  end

  #get a full report of what will be done if you sync. what will be imported/exported/deleted...etc
  def get_pre_sync_report
    {
      :to_be_deleted_localy => sync_remote_deletes_with_local_contacts(true),
      :to_be_deleted_remotly => sync_local_deletes_with_remote_contacts(true),
      :to_be_imported => get_to_be_imported_contacts,
      :to_be_exported => get_to_be_exported_contacts[:contact_hashs]
    }
  end

  private
  #will try to import all contacts that are to_be_imported
  #a hash will be returned with details of the operation
  def import_contacts
    importing_was_ok = true
    number_of_contacts_imported = 0

    get_to_be_imported_contacts.each do |contact|

      unless Contact.new({
            :first_name => contact[:first_name],
            :last_name => contact[:last_name],
            :email => contact[:emails].first,
            :note => contact[:note],
            :contact_source => self,
            :user => user,
            :contact_sources => [self]
          }).save

        importing_was_ok = false
        break
      end
      number_of_contacts_imported +=1
    end
    
    {:importing_was_ok => importing_was_ok, :number_of_contacts_imported => number_of_contacts_imported}
  end

  #export the to_be_exported contacts. they are in the hash format
  def export_contacts
    #if the current contact manager does not support contact exporting just return 0
    return 0 unless get_contact_manager.support_exporting?
    
    #if it supports it let's continue.
    result = get_to_be_exported_contacts

    #get all the contact objects that are going to be exported
    #and mark them as synced
    result[:contacts].each{|contact| contact.contact_sources << self; contact.save}

    get_contact_manager.export_contacts result[:contact_hashs]
  end

  #returns a set of contacts that will be imported in a sync. this is in the hash format
  def get_to_be_imported_contacts
    contacts_to_be_imported = []
    #we need to get even the deleted here because when we are showing the to be imported
    #contact list to the user. it will include contacts that are deleted =true but are
    #yet to be remotly deleted. and they will be imported again when we import contacts
    if get_contact_manager.support_importing?
      unicon_contacts = Contact.all_including_deleted user_id
      provider_contacts = get_contact_manager.all_contacts_as_hash
      
      if unicon_contacts.length > 0
        provider_contacts.each {|pcontact|
          provider_contact_should_be_imported = true
          unicon_contacts.each{|contact|
            if contact.is_a_equal_contact_as_a_hash? pcontact
              provider_contact_should_be_imported = false
              break
            end
          }
          contacts_to_be_imported << pcontact if provider_contact_should_be_imported
        }
      else
        return provider_contacts
      end

    end
    contacts_to_be_imported
  end


  #get a array of contacts and contact hashs that need to be exported to the remote contact source
  #results[:contacts] => contact objects
  #results[:contact_hashs] => contacts as hashs
  def get_to_be_exported_contacts
    contacts_to_be_exported = {:contacts => [], :contact_hashs => []}

    if get_contact_manager.support_exporting?
      unicon_contacts = Contact.contacts_to_be_exported user_id, self
      provider_contacts = get_contact_manager.all_contacts_as_hash

      unicon_contacts.each {|contact|
        contact_should_be_exported = true
        provider_contacts.each{|pcontact|
          if contact.is_a_equal_contact_as_a_hash? pcontact
            contact_should_be_exported = false
            break
          end
        }
        if contact_should_be_exported
          contacts_to_be_exported[:contact_hashs] << contact.get_contact_as_a_hash
          contacts_to_be_exported[:contacts] << contact
        end

      }
    end

    contacts_to_be_exported
  end

  #check for already synced contacts that are deleted localy. and delete them in their remote source
  #when used with the test_drive => true this will not delete the contacts. but will return a to_be_deleted
  #list of contact hashs
  def sync_local_deletes_with_remote_contacts test_drive
    result = []

    if get_contact_manager.support_deleting?
      provider_contacts = get_contact_manager.all_contacts_as_hash

      #Contact.to_be_remotly_deleted_contacts(user_id, self).each {|deleted_ucontact|
      Contact.get_synced_contacts(user_id, self, true).each {|deleted_ucontact|
        provider_contacts.each {|pcontact|
          if deleted_ucontact.is_a_equal_contact_as_a_hash? pcontact
            result << pcontact

            unless test_drive
              get_contact_manager.delete_contact pcontact #delete remotely
              deleted_ucontact.contact_sources.delete self #the contact is no more synced with this contact source
              #delete localy if this is not synced with any other contact sources
              deleted_ucontact.sync_safe_delete
            end
          end
        }
      }

    end

    result
  end

  #check for already synced contacts that are deleted remotly. and delete them in localy
  #when used with the test_drive => true this will not really delete the contacts.
  #but will return a to_be_deleted list of contact hashs
  #if test_drive => false this will return a list of deleted contact's hashs
  def sync_remote_deletes_with_local_contacts test_drive
    result = []

    if get_contact_manager.support_deleting?
      provider_contacts = get_contact_manager.all_contacts_as_hash

      #Contact.synced_but_not_deleted_contacts(user_id).each{|ucontact|
      Contact.get_synced_contacts(user_id, self, false).each{|ucontact|
        ucontact_deleted_remotly = true

        provider_contacts.each {|pcontact|
          ucontact_deleted_remotly = !ucontact.is_a_equal_contact_as_a_hash?(pcontact)
          break unless ucontact_deleted_remotly
        }

        if ucontact_deleted_remotly
          result << ucontact.get_contact_as_a_hash
          ucontact.destroy unless test_drive
        end
      }
    end

    result
  end

  #get a contact manager relavant to the provider. ie: if the provider is type of gmail a contact manager of
  #GmailContactManager will be returned
  def get_contact_manager
    case provider
      when "gmail" then return GmailContactManager.new self
      when "twitter" then return TwitterContactManager.new self
    end
  end

end
