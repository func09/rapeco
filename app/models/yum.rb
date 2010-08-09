require 'open-uri'
require 'twitpic'
require 'twitpic2'
class Yum < ActiveRecord::Base
  include Pacecar
  include ActionView::Helpers::TextHelper
  
  has_many :comments
  has_friendly_id :uid
  belongs_to :user, :counter_cache => true
  
  UID_LENGTH = 8
  
  attr_accessor :tweetable
  attr_accessor :upload_image
  
  default_value_for :uid do
    Forgery(:basic).text(:at_least => UID_LENGTH, :at_most => UID_LENGTH, :allow_upper => false)
  end

  default_value_for :tweetable, :true
  
  named_scope :recented,
    :order => 'created_at DESC'
  
  named_scope :enables,
    :conditions => ['not_yummy_image = ?', false]
  
  named_scope :recent, 
    :conditions => ['not_yummy_image = ? AND created_at >= ?', false, 24.hours.ago], 
    :order => 'created_at DESC'        
    
  named_scope :hot, 
    :conditions => ['not_yummy_image = ? AND created_at >= ?', false, 24.hours.ago], 
    :order => 'yummy_point DESC, updated_at DESC'
              
  named_scope :popular, 
    :conditions => ['not_yummy_image = ? AND created_at >= ? AND yummy_count > 0 AND view_count >= 10', false, 3.month.ago], 
    :order => 'yummy_point DESC, updated_at DESC'
  
  validates_presence_of :photo_service
  validates_presence_of :photo_url
  validates_presence_of :uploaded_at
  validates_uniqueness_of :photo_url
  
  before_save :calc_yummy_point
  
  def view!
    self.increment!(:view_count)
  end
  
  def vote!
    self.increment!(:yummy_count)
  end
  
  def report!
    self.increment!(:report_count)
  end
  
  # ランキングを決めるアルゴリズム
  # コメント > 投票 > 見る = 10 : 5 : 1
  def calc_yummy_point
    self.yummy_point = (self.comments_count * 10) + ( view_count * 1 ) + ( yummy_count * 5 )
  end
  
  def image_url(options = {:size => :thumb})
    photo = PhotoService.get_instance(self.photo_service, self.photo_url)
    return photo.image_url(:size)
  end
  
  # 新規作成時の検証前処理
  def before_validation_on_create
    
    if self.upload_image
      # TwitPicへアップロード
      res = upload_to_twitpic(self.upload_image)
      self.photo_service = 'twitpic'
      self.photo_url = res["url"]
      self.uploaded_at = Time.now
    else
    end
    
  end
  
  # 新規作成後
  def after_create
    logger.info "After Create Yum"
    logger.info "tweetable #{self.tweetable}"
    if self.tweetable == true or self.tweetable == '1'
      # ツイートする
      update_tweet(self.text)
    end
  end
  
  private
    
    # TwitPicへアップロードする
    # @param [User] user
    # @param [File] image_file
    # @return [Hash]
    def upload_to_twitpic(image_file)
      logger.info("TwitPicへアップロードします")
      tp = TwitPic2.new(configatron.twitpic.api_key, configatron.twitter.app.oauth_consumer_key,configatron.twitter.app.oauth_consumer_secret)
      res = tp.upload(image_file.path, self.user.access_token, self.user.access_secret)
      logger.info("TwitPicへアップロードが成功しました： #{res['url']}")
      return res
    end
    
    # ツイートする
    # 
    def update_tweet(text)
      suffix = " #{configatron.host}/#{self.uid} ##{configatron.twitter.hashtag}"
      text = truncate(text, :length => 140 - suffix.length )
      message = "#{text}#{suffix}"
      res = self.user.twitter.post('/statuses/update.json', 'status' => message)
    end
  
end

# == Schema Information
#
# Table name: yums
#
#  id              :integer         not null, primary key
#  photo_service   :string(255)
#  photo_url       :string(255)
#  view_count      :integer         default(0)
#  yummy_count     :integer         default(0)
#  yummy_point     :integer         default(0)
#  not_yummy_image :boolean         default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#  report_count    :integer         default(0)
#  uploaded_at     :datetime
#  user_id         :integer
#  uid             :string(255)
#  text            :string(140)
#  comments_count  :integer         default(0)
#

