class CreateYums < ActiveRecord::Migration
  def self.up
    create_table :yums do |t|
      t.string    :photo_service
      t.string    :photo_url
      t.integer   :view_count, :default => 0
      t.integer   :yummy_count, :default => 0
      t.integer   :yummy_point, :default => 0
      t.integer   :tweets_count, :default => 0
      t.boolean   :not_yummy_image, :default => false
      t.timestamps
    end
    add_index :yums, [:photo_url], :unique => true
  end

  def self.down
    drop_table :yums
  end
end
