class AddServicePassSha1HashToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :service_hash, :string
  end

  def self.down
    remove_column :users, :service_hash
  end
end
