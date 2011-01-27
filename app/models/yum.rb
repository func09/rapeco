require 'open-uri'
require 'twitpic'
require 'twitpic2'
class Yum < ActiveRecord::Base
  
  include ActionView::Helpers::TextHelper
  
  # Relations
  belongs_to :user, :counter_cache => true
  has_many :comments
  
  # Attributes
  attr_accessor :tweetable, :upload_image
  has_friendly_id :uid
  
  # Default Values
  default_value_for :uid do
    Forgery(:basic).text(:at_least => 6, :at_most => 6)
  end
  default_value_for :tweetable, :true
  
  # Validations
  validates_presence_of :photo_service
  validates_presence_of :photo_url
  validates_presence_of :uploaded_at
  validates_uniqueness_of :photo_url
  
  # Scope
  scope :recented, order('created_at DESC')
  scope :enables, where(['not_yummy_image = ?', false])
  scope :recent, enables.where(['created_at >= ?', 7.days.ago]).recented
  scope :hot, enables.where(['created_at >= ?', 7.days.ago]).order('yummy_point DESC, updated_at DESC')
  scope :popular, where(:not_yummy_image => false).where(['created_at >= ?', 12.month.ago]).order('yummy_point DESC, updated_at DESC')
  
  # Callbacks
  before_save :calc_yummy_point
  before_validation(:on => :create) do
    if self.upload_image
      # TwitPicへアップロード
      res = upload_to_twitpic(self.upload_image.tempfile)
      self.photo_service = 'twitpic'
      self.photo_url = res["url"]
      self.uploaded_at = Time.now
    end
  end
  
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
#  twitter_id      :string(255)
#

