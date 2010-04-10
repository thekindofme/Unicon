class CreateAdvertisements < ActiveRecord::Migration
  def self.up
    create_table :advertisements do |t|
      t.text :link
      t.text :description
      t.text :contact_details
      t.timestamps
    end
  end

  def self.down
    drop_table :advertisements
  end
end
