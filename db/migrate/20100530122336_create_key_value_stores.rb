class CreateKeyValueStores < ActiveRecord::Migration
  def self.up
    create_table :key_value_stores do |t|
      t.string :key
      t.text :data
      t.timestamps
    end
  end

  def self.down
    drop_table :key_value_stores
  end
end
