class AddReportCountToYums < ActiveRecord::Migration
  def self.up
    add_column :yums, :report_count, :integer, :default => 0
  end

  def self.down
    remove_column :yums, :report_count
  end
end
