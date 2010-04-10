require 'rubygems'
require 'twitter'

class TwitterContactManager < AbstractContactManager
  #contact manager depends on the contact source to get authentication info on
  #connecting to the contact provider(gmail, yahoo...etc)
  def initialize contact_source
    @contact_source = contact_source
    @twitter = Twitter::Base.new(Twitter::HTTPAuth.new @contact_source.username, @contact_source.password)

  end

  #wether you can export contacts using export_contacts or not
  def support_exporting?
    false
  end

  #is deleting contacts supported?
  def support_deleting?
    false
  end

  #supports importing all the contacts as a hash(using all_contacts_as_hash)?
  def support_importing?
    true
  end

  #retrives all the contacts from the provider as a hash
  def all_contacts_as_hash
    contacts = []
    @twitter.friends.each do |friend|
      contacts << contact_to_hash(friend)
    end
    contacts
  end

  protected
  #convert a provider specific contact object to a hash
  def contact_to_hash contact
    {
      :first_name => contact.screen_name,
      :last_name => contact.screen_name,
      :nick => contact.screen_name,
      :url => contact.url,
      :note => contact.description,
      :image_url => contact.profile_image_url,
      :emails => ["#{contact.screen_name}@twitter.com"],
      :ref_to_pcontact_obj => contact
    }
  end
end
