class RecreateBackupTable < ActiveRecord::Migration
  def self.up
    drop_table :backup
    create_table :backup do |t|
      t.string :trigger
      t.string :adapter
      t.string :filename
      t.string :md5sum
      t.string :path
      t.string :bucket
      t.string :type
      t.timestamps          
    end
  end

  def self.down
    drop_table :backup
    create_table :backup do |t|
      t.string :storage
      t.string :trigger
      t.string :adapter
      t.string :filename
      t.string :path
      t.string :bucket
      t.timestamps          
    end
  end
end
