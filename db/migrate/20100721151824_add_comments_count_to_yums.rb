class AddCommentsCountToYums < ActiveRecord::Migration
  def self.up
    add_column :yums, :comments_count, :integer, :default => 0
    Yum.find_each do |yum|
      yum.update_attribute :comments_count, yum.comments.count
    end
  end

  def self.down
    remove_column :yums, :comments_count
  end
end
