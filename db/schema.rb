# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090804003907) do

  create_table "advertisements", :force => true do |t|
    t.text     "link"
    t.text     "description"
    t.text     "contact_details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_sources", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password"
    t.string   "note"
    t.integer  "user_id"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "nick"
    t.string   "login_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "note"
    t.text     "url"
    t.text     "image_url"
    t.string   "domain"
    t.integer  "contact_source_id"
    t.integer  "user_id"
    t.boolean  "deleted",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts_synced_with_contact_sources", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "contact_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                 :null => false
    t.integer  "login_count",       :default => 0,  :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.string   "perishable_token",  :default => "", :null => false
    t.string   "email",             :default => "", :null => false
    t.string   "openid_identifier"
    t.string   "service_hash"
  end

  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["openid_identifier"], :name => "index_users_on_openid_identifier"

end
