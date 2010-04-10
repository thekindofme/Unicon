class CreateContactsSyncedWithContactSources < ActiveRecord::Migration
  def self.up
    create_table :contacts_synced_with_contact_sources do |t|
      t.column :contact_id, :integer
      t.column :contact_source_id, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts_synced_with_contact_sources
  end
end
