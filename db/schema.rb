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

ActiveRecord::Schema.define(:version => 20091207091233) do

  create_table "areas", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendors_count", :default => 0
  end

  add_index "areas", ["parent_id"], :name => "area_parent_id"

  create_table "attachments", :force => true do |t|
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", :force => true do |t|
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.integer  "time_range"
    t.integer  "guest_count"
    t.string   "requirment"
    t.integer  "bookable_id"
    t.string   "bookable_type"
    t.string   "contact"
    t.string   "email"
    t.string   "mobile"
    t.integer  "discount_id"
    t.integer  "discount_version"
    t.string   "status"
  end

  create_table "bookings_mobile_users", :id => false, :force => true do |t|
    t.integer "mobile_user_id"
    t.integer "booking_id"
  end

  create_table "cards", :force => true do |t|
    t.string   "name"
    t.integer  "point"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comatose_page_versions", :force => true do |t|
    t.integer  "comatose_page_id"
    t.integer  "version"
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type",      :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                       :default => 0
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  create_table "comatose_pages", :force => true do |t|
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                  :default => 0
    t.integer  "version"
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commissions", :force => true do |t|
    t.integer  "booking_id"
    t.integer  "booking_charge"
    t.integer  "official"
    t.integer  "user"
    t.boolean  "valid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contactable_id"
    t.string   "contactable_type"
  end

  create_table "discount_versions", :force => true do |t|
    t.integer "discount_id"
    t.integer "version"
    t.float   "count"
    t.string  "description"
    t.date    "start_date"
    t.date    "stop_date"
    t.time    "start_at"
    t.time    "stop_at"
    t.string  "name"
  end

  create_table "discounts", :force => true do |t|
    t.integer  "user_id"
    t.float    "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.date     "start_date"
    t.date     "stop_date"
    t.time     "start_at"
    t.time     "stop_at"
    t.string   "name"
    t.integer  "version",     :default => 1
    t.string   "status"
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "parent_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchants", :force => true do |t|
    t.string   "name"
    t.string   "contact"
    t.integer  "tel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pending",    :default => true
  end

  create_table "mobile_users", :force => true do |t|
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     :default => "pending"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "count",      :default => 0
    t.integer  "vendor_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.text     "body"
    t.integer  "vendor_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "score_sumaries", :force => true do |t|
    t.integer  "vote_id"
    t.float    "score",      :default => 0.0
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "score_sumaries", ["vendor_id", "vote_id"], :name => "score_sumaries_vendor_id_vote_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "forum_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "types", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "types", ["parent_id"], :name => "index_types_on_parent_id"

  create_table "types_vendors", :id => false, :force => true do |t|
    t.integer "vendor_id"
    t.integer "type_id"
  end

  add_index "types_vendors", ["type_id"], :name => "index_types_vendors_on_type_id"
  add_index "types_vendors", ["vendor_id"], :name => "index_types_vendors_on_vendor_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "merchant_id"
    t.integer  "avatar_left"
    t.integer  "avatar_right"
    t.integer  "avatar_top"
    t.integer  "avatar_bottom"
    t.string   "mobile"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "vendor_versions", :force => true do |t|
    t.integer  "vendor_id"
    t.integer  "version"
    t.integer  "author_id"
    t.integer  "tel1"
    t.integer  "area_id"
    t.integer  "category_id"
    t.string   "name"
    t.string   "address"
    t.string   "nearby"
    t.string   "alias"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tags"
    t.string   "nickname" 
    t.string   "category" 
    t.integer  "phone"   
    t.integer  "sum" 
    t.integer  "env"
    t.integer  "taste"
    t.integer  "avg"
    t.integer  "service"
    t.integer  "reviews_count", :default => 0
    t.integer  "merchant_id"
    t.integer  "discount_id"
    t.boolean  "pending",       :default => true
    t.integer  "creator_id"
    t.integer  "author_id"
    t.integer  "version",       :default => 1
  end


  create_table "votes", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "spec"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  add_index "votes", ["category_id", "spec"], :name => "votes_category_id_spec"
  add_index "votes", ["short_name"], :name => "votes_short_name"

end
