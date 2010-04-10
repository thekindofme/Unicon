class ContactsSyncedWithContactSource < ActiveRecord::Base
  belongs_to :contact
  belongs_to :contact_source

  #validation
  validates_presence_of :contact_id, :contact_source_id
end
