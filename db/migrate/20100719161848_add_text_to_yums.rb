class AddTextToYums < ActiveRecord::Migration
  def self.up
    add_column :yums, :text, :string, :limit => 140
    
    # Delete Non Users
    Yum.find_each(:conditions => ['user_id IS NULL']) do |yum|
      yum.destroy
    end
    
    Yum.find_each(:conditions => ['tweets_count > ?',0]) do |yum|
      tweet = yum.tweets.find(:first, :order => 'tweeted_at ASC')
      yum.update_attribute :text, 
                           tweet.text.gsub(URI.regexp(['http', 'https', 'ftp']),'').
                           gsub(/#[\w]+/,'').
                           gsub(/\s+/,' ')
    end
    
  end

  def self.down
    remove_column :yums, :text
  end
end
