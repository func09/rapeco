class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer   :yum_id, :null => false
      t.integer   :status_id, :null => false, :limit => 5
      t.string    :text
      t.string    :from_user
      t.integer   :from_user_id
      t.string    :geo
      t.string    :profile_image_url
      t.datetime  :tweeted_at
      t.timestamps
    end
    add_index :tweets, [:status_id], :unique => true
    add_index :tweets, [:from_user_id]
  end

  def self.down
    drop_table :tweets
  end
end
