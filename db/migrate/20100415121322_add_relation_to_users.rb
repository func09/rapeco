class AddRelationToUsers < ActiveRecord::Migration
  def self.up
    add_column :yums, :user_id, :integer
    add_index :yums, [:user_id]
  end

  def self.down
    remove_column :yums, :user_id
    remove_index :yums, :column => [:user_id]
  end
end
