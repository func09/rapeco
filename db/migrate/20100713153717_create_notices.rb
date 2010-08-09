class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.string :title, :null => false
      t.text :body
      t.date :published_at, :null => false
      t.boolean :hidden, :default => false
      t.boolean :impotant, :default => false
      t.string :type, :null => false, :default => 'NoticeNew'
      t.timestamps
    end
  end

  def self.down
    drop_table :notices
  end
end
