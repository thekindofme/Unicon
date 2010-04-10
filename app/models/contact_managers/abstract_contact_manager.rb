#This class shows the basic sturcture for a contcat manager
#all and any contact manager under unicon should support these methods
class AbstractContactManager

  #return a arry containing strings representing all aviliable contact managers
  #ex:-
  ## AbstractContactManager.all => ["gmail", "twitter"]
  def self.all
    ["gmail", "twitter"]
  end

  #contact manager depends on the contact source to get authentication info on
  #connecting to the contact provider(gmail, yahoo...etc)
  def initialize contact_source
  end

  #wether you can export contacts using export_contacts or not
  def support_exporting?

  end

  #will export the provided contacts(a array of hashes), and return a results hash
  def export_contacts contacts_as_hashes
  end

  #is deleting contacts supported?
  def support_deleting?

  end

  #delete a contact that coresponds to the given hash, in the provider
  def delete_contact contact_as_a_hash
  end

  #supports importing all the contacts as a hash(using all_contacts_as_hash)?
  def support_importing?

  end

  #retrives all the contacts from the provider as a hash
  def all_contacts_as_hash
  end

  protected
  #convert a provider specific contact object to a hash
  def contact_to_hash contact
  end

  #'convert' a contact as a hash to a provider specific contact object
  def contact_from_contact_as_a_hash contact_as_a_hash
    contact_as_a_hash[:ref_to_pcontact_obj]
  end
end
