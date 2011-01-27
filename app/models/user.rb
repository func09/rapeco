class User < TwitterAuth::GenericUser
  has_friendly_id :login
  
  has_many :yums, :conditions => ['not_yummy_image = ?',false]
  has_many :comments
  has_many :receive_comments, 
    :foreign_key => :to_user_id, 
    :class_name => 'Comment', 
    :readonly => true, 
    :order => 'created_at DESC',
    :conditions => ['user_id != to_user_id']
  named_scope :hot,
    :from => 'users, (SELECT user_id, SUM(yummy_point) AS point FROM yums GROUP BY user_id) as v',
    :conditions => ['users.id = v.user_id'],
    :order => 'point DESC'
              
  named_scope :recent,
    :order => 'created_at DESC'
  
end

# == Schema Information
#
# Table name: users
#
#  id                           :integer         not null, primary key
#  twitter_id                   :string(255)
#  login                        :string(255)
#  access_token                 :string(255)
#  access_secret                :string(255)
#  remember_token               :string(255)
#  remember_token_expires_at    :datetime
#  unsignuped                   :boolean
#  name                         :string(255)
#  location                     :string(255)
#  description                  :string(255)
#  profile_image_url            :string(255)
#  url                          :string(255)
#  protected                    :boolean
#  profile_background_color     :string(255)
#  profile_sidebar_fill_color   :string(255)
#  profile_link_color           :string(255)
#  profile_sidebar_border_color :string(255)
#  profile_text_color           :string(255)
#  profile_background_image_url :string(255)
#  profile_background_tile      :boolean
#  friends_count                :integer
#  statuses_count               :integer
#  followers_count              :integer
#  favourites_count             :integer
#  utc_offset                   :integer
#  time_zone                    :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  yums_count                   :integer         default(0)
#  comments_count               :integer         default(0)
#  receive_comments_count       :integer         default(0)
#

