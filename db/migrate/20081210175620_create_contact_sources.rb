class CreateContactSources < ActiveRecord::Migration
  def self.up
    create_table :contact_sources do |t|
      t.string :name
      t.string :username
      t.string :password
      t.string :note
      t.integer :user_id
      t.string :provider
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_sources
  end
end
