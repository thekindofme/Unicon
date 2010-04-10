class CreateRoles < ActiveRecord::Migration
    def self.up
      create_table :roles do |t|
        t.column :name, :string
      end

      add_index :roles, :name
      
      #by default create a admin role
      Role.create(:name => "admin")

    end

    def self.down
      drop_table :roles
    end
end
