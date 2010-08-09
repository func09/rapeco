class AddTwitterUserIdToYums < ActiveRecord::Migration
  def self.up
    add_column :yums, :twitter_id, :string
    
    Yum.find_each do |yum|
      twitter_id = yum.user_id
      if user = User.find_by_twitter_id(twitter_id)
        yum.user_id = user.id
        yum.twitter_id = twitter_id
        if yum.valid?
          yum.save
        end
      end
    end
    
  end

  def self.down
    Yum.find_each do |yum|
      yum.user_id = yum.twitter_id
      if yum.valid?
        yum.save
      end
    end
    remove_column :yums, :twitter_user_id
  end
end
