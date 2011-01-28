class Comment < ActiveRecord::Base
  
  # Relations
  belongs_to :yum, :counter_cache => true, :foreign_key => 'yum_id'
  belongs_to :user, :counter_cache => true
  belongs_to :to_user, :class_name => 'User', :counter_cache => :receive_comments_count
  
  # Validations
  validates_presence_of :user_id
  validates_length_of :comment, :in => 1..140
  
  # Attributes
  attr_accessor :will_tweet
  default_value_for :comment do
    "ハラペコなう！"
  end
  
  # Callback
  after_create :tweet
  before_validation_on_create :check_to_user
  
  # Scope
  default_scope :order => 'created_at ASC'
  scope :recent, order('created_at DESC')
  
  # 自分から自分へのコメントは省く
  scope :exclude_self, where('user_id != to_user_id')
  
  
  def will_tweet?
    self.will_tweet == '1'
  end
  
  def tweet
    if self.will_tweet?
      logger.info 'コメントをツイートします'
      message_extention = " #{configatron.host}/#{self.yum.uid} ##{configatron.twitter.hashtag}"
      message = "#{self.comment}#{message_extention}"
      self.user.twitter.post('/statuses/update.json', 'status' => message)
    end
  end
  
  private
    def check_to_user
      unless self.to_user_id
        self.to_user_id = self.yum.user.id
      end
    end
  
end

# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  comment    :string(140)     default("")
#  yum_id     :integer
#  user_id    :integer         not null
#  created_at :datetime
#  updated_at :datetime
#  to_user_id :integer
#

