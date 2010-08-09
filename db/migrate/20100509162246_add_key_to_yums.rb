class AddKeyToYums < ActiveRecord::Migration
  def self.up
    add_column :yums, :uid, :string
    add_index :yums, [:uid], :unique => true
  end

  def self.down
    remove_index :yums, :column => [:uid]
    remove_column :yums, :uid
  end
end
