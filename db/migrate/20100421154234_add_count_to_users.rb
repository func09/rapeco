class AddCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :yums_count, :integer, :default => 0
    add_column :users, :tweets_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :yums_count
    remove_column :users, :tweets_count
  end
end
