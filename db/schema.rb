# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110130033026) do

  create_table "admin_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true

  create_table "backup", :force => true do |t|
    t.string   "trigger"
    t.string   "adapter"
    t.string   "filename"
    t.string   "md5sum"
    t.string   "path"
    t.string   "bucket"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string    "comment",    :limit => 140
    t.integer   "yum_id"
    t.integer   "user_id",                   :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "to_user_id"
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"
  add_index "comments", ["yum_id"], :name => "index_comments_on_commentable_id"

  create_table "key_value_stores", :force => true do |t|
    t.string    "key"
    t.text      "data"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "notices", :force => true do |t|
    t.string    "title",                                 :null => false
    t.text      "body"
    t.date      "published_at",                          :null => false
    t.boolean   "hidden",       :default => false
    t.boolean   "impotant",     :default => false
    t.string    "type",         :default => "NoticeNew", :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string    "name"
    t.integer   "sluggable_id"
    t.integer   "sequence",                     :default => 1, :null => false
    t.string    "sluggable_type", :limit => 40
    t.string    "scope"
    t.timestamp "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

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

  create_table "users", :force => true do |t|
    t.string    "twitter_id"
    t.string    "login"
    t.string    "access_token"
    t.string    "access_secret"
    t.string    "remember_token"
    t.timestamp "remember_token_expires_at"
    t.boolean   "unsignuped"
    t.string    "name"
    t.string    "location"
    t.string    "description"
    t.string    "profile_image_url"
    t.string    "url"
    t.boolean   "protected"
    t.string    "profile_background_color"
    t.string    "profile_sidebar_fill_color"
    t.string    "profile_link_color"
    t.string    "profile_sidebar_border_color"
    t.string    "profile_text_color"
    t.string    "profile_background_image_url"
    t.boolean   "profile_background_tile"
    t.integer   "friends_count"
    t.integer   "statuses_count"
    t.integer   "followers_count"
    t.integer   "favourites_count"
    t.integer   "utc_offset"
    t.string    "time_zone"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "yums_count",                   :default => 0
    t.integer   "comments_count",               :default => 0
    t.integer   "receive_comments_count",       :default => 0
  end

  create_table "yums", :force => true do |t|
    t.string    "photo_service"
    t.string    "photo_url"
    t.integer   "view_count",                     :default => 0
    t.integer   "yummy_count",                    :default => 0
    t.integer   "yummy_point",                    :default => 0
    t.boolean   "not_yummy_image",                :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "report_count",                   :default => 0
    t.timestamp "uploaded_at"
    t.integer   "user_id"
    t.string    "uid"
    t.string    "text",            :limit => 140
    t.integer   "comments_count",                 :default => 0
    t.string    "twitter_id"
  end

  add_index "yums", ["photo_url"], :name => "index_yums_on_photo_url", :unique => true
  add_index "yums", ["uid"], :name => "index_yums_on_uid", :unique => true
  add_index "yums", ["user_id"], :name => "index_yums_on_user_id"

end
