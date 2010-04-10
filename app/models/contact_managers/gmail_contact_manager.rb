require 'contact_managers/abstract_contact_manager'

#we are using a java library. so import all the nesseary stuff
require 'java'

import com.google.gdata.client.Query;
import com.google.gdata.client.contacts.ContactsService;
import com.google.gdata.client.http.HttpGDataRequest;
import com.google.gdata.data.DateTime;
import com.google.gdata.data.Link;
import com.google.gdata.data.PlainTextConstruct;
import com.google.gdata.data.contacts.ContactEntry;
import com.google.gdata.data.contacts.ContactFeed;
import com.google.gdata.data.contacts.ContactGroupEntry;
import com.google.gdata.data.contacts.ContactGroupFeed;
import com.google.gdata.data.contacts.GroupMembershipInfo;
import com.google.gdata.data.extensions.Email;
import com.google.gdata.data.extensions.ExtendedProperty;
import com.google.gdata.data.extensions.Im;
import com.google.gdata.data.extensions.OrgName;
import com.google.gdata.data.extensions.OrgTitle;
import com.google.gdata.data.extensions.Organization;
import com.google.gdata.data.extensions.PhoneNumber;
import com.google.gdata.data.extensions.PostalAddress;
import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ServiceException;
import com.google.gdata.util.XmlBlob;

#manage every aspect of gmail contact source.
class GmailContactManager < AbstractContactManager

  #creates a new instance of GmailContactManager while extracting user credentials from the given ContactSource
  def initialize contact_source
    @contact_source = contact_source

    @myService = Java::com.google.gdata.client.contacts.ContactsService.new "unicon-unicon-1"
    #@myService.setUserCredentials("hwijesureeya@gmail.com", "IGTF*S^&888sf");
    @myService.setUserCredentials("#{@contact_source.username}@gmail.com", @contact_source.password);
  end

  def support_deleting?
    true
  end

  def support_exporting?
    true
  end

  def support_importing?
    true
  end

  #will export the provided contacts(a array of hashes), and return a results hash
  def export_contacts contacts_as_hashes
    contacts_exported = 0
    #contacts_exporting_succsesful = true

    contacts_as_hashes.each{|contact_hash|
      new_contact = ContactEntry.new
      new_contact.setTitle PlainTextConstruct.new(contact_hash[:first_name] + " " + contact_hash[:last_name])
      new_contact.setContent PlainTextConstruct.new(contact_hash[:note])

      contact_hash[:emails].each { |uni_email|
        email = Email.new
        email.setAddress uni_email
        email.setRel "http://schemas.google.com/g/2005#home"
        #email.setPrimary true if contact_hash.first.eql uni_email
        new_contact.addEmailAddress email
      }

      @myService.insert feed_url, new_contact
      contacts_exported+=1
    }
    {:contacts_exported => contacts_exported}
  end

  #delete a contact that coresponds to the given hash, in the provider
  def delete_contact contact_as_a_hash
    contact_from_contact_as_a_hash(contact_as_a_hash).delete
  end

  #retrives all the contacts from the provider as a hash
  def all_contacts_as_hash
    results = [] #results array
    all_contacts.each { |entry| results << contact_to_hash(entry) }
    results
  end

  protected
  #convert a ContactEntry to a hash
  def contact_to_hash contact
    emails = []
    for email in contact.getEmailAddresses
      emails << email.getAddress
    end

    first_name="not yet set"
    last_name= "not yet set"
    title_in_plain_text = contact.getTitle.getPlainText
    last_name = title_in_plain_text.split(" ").last
    first_name = title_in_plain_text.gsub " " + last_name, "" if last_name != nil
    return {
      :first_name => first_name,
      :last_name => last_name,
      :emails => emails,
      #:note => gcontact.getContent.getPlainText,
      :note => "failed to get notes",
      :ref_to_pcontact_obj => contact
    }
  end

  private
  #get a feed url which needed to talk to the google contact api
  #it would look like
  # "http://www.google.com/m8/feeds/contacts/#username@gmail.com/full"
  def feed_url
    Java::JavaNet::URL.new "http://www.google.com/m8/feeds/contacts/#{@contact_source.username}@gmail.com/full"
  end

  #give all the contacts in a gmail account as ContactEntry objects
  def all_contacts
    #Request the feed
    query = Query.new(feed_url)
    query.setMaxResults 99999999 #set the max results to a very large number to get all the contacts
    @myService.query(query, ContactFeed.java_class).getEntries
  end
end
