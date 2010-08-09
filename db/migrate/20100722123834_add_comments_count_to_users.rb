class AddCommentsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :comments_count, :integer, :default => 0
    add_column :users, :receive_comments_count, :integer, :default => 0
    
    User.find_each do |user|
      user.comments_count = Comment.count(:conditions => ['user_id = ?', user.id])
      user.receive_comments_count = Comment.count(:conditions => ['to_user_id = ? AND user_id != to_user_id', user.id])
      user.save!
    end
    
  end

  def self.down
    remove_column :users, :comments_count
    remove_column :users, :receive_comments_count
  end
end
