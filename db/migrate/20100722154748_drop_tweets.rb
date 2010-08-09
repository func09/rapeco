class DropTweets < ActiveRecord::Migration
  def self.up
    remove_index :tweets, :column => [:from_user_id]
    remove_index :tweets, :column => [:status_id]
    drop_table :tweets
    
    remove_column :yums, :tweets_count
    remove_column :users, :tweets_count
    
  end

  def self.down
    add_column :yums, :tweets_count, :integer, :default => 0
    add_column :users, :tweets_count, :integer, :default => 0
    create_table "tweets", :force => true do |t|
      t.integer   "yum_id",            :null => false
      t.integer   "status_id",         :null => false
      t.string    "text"
      t.string    "from_user"
      t.integer   "from_user_id"
      t.string    "geo"
      t.string    "profile_image_url"
      t.timestamp "tweeted_at"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    add_index "tweets", ["from_user_id"], :name => "index_tweets_on_from_user_id"
    add_index "tweets", ["status_id"], :name => "index_tweets_on_status_id", :unique => true
  end
end
