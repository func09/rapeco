class UnpolymorphicComments < ActiveRecord::Migration
  def self.up
    rename_column :comments, :commentable_id, :yum_id
    remove_column :comments, :commentable_type
    add_column :comments, :to_user_id, :integer
    Comment.find_each do |comment|
      if yum = Yum.find(:first, :conditions => ['id = ?',comment.yum_id], :include => [:user])
        comment.update_attribute :to_user_id, yum.user.id
      end
    end
  end

  def self.down
    remove_column :comments, :to_user_id
    rename_column :comments, :yum_id, :commentable_id
    add_column :comments, :commentable_type, :string
    Comment.find_each do |comment|
      comment.update_attribute :commentable_type, 'Yum'
    end
  end
end
