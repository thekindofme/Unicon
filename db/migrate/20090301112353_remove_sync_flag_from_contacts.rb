class RemoveSyncFlagFromContacts < ActiveRecord::Migration
  def self.up
    remove_column :contacts, :synced
  end

  def self.down
    add_column :contacts, :synced
  end
end
