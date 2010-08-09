require 'open-uri'
class AddUploadedAtToYums < ActiveRecord::Migration
  def self.up
    add_column :yums, :uploaded_at, :datetime
#    Tweet.find(:all, :group => 'yum_id', :include => [:yum], :order => 'tweeted_at ASC').each do |tweet|
#      Yum.transaction do
#        tweet.yum.update_attribute :uploaded_at, tweet.tweeted_at
#        p "#{tweet.yum.id} update"
#      end
#    end
  end

  def self.down
    remove_column :yums, :uploaded_at
  end
end
