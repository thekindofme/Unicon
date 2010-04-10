class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :nick
      t.string :login_name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text    :note
      t.text    :url
      t.text    :image_url
      t.string :domain
      t.integer :contact_source_id
      t.integer :user_id
      t.boolean :deleted, :default => false
      t.boolean :synced, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
