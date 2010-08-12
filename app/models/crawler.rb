class Crawler
  
  class << self
    
    include ActionView::Helpers::TextHelper

    def logger
      RAILS_DEFAULT_LOGGER
    end
    
    # アップロード用のTwitterアカウントのmentionsをチェックして
    # 画像をアップロードするバッチ処理
    def check_upload
      
      logger.info "投稿アカウントのmentionsチェック"
      
      results = []
      
      # twitter
      upload_user = User.find_by_login(configatron.twitter.upload_user)
      
      # mentions 取得
      if since_id = Rails.cache.write(:update_check_since_id)
        mentions = upload_user.twitter.get('/statuses/mentions.json', 'since_id' => since_id.to_s)
      else
        mentions = upload_user.twitter.get('/statuses/mentions.json')
      end
      mentions.each do |mention|
        
        # 写真URLを含み、登録ユーザーのツイートであり、まだ登録されていない画像であるならば
        # 写真URLを含むか
        if photoinfo = PhotoService.find_in_text(mention['text'])
          
          logger.info photoinfo
          
          # まだ登録されていない画像 && 登録ユーザーであれば
          if !Yum.exists?(['photo_url = ?', photoinfo.url]) && user = User.find_by_twitter_id(mention['user']['id'])
            
            text = mention['text'].gsub(photoinfo.url,'').gsub(/\s?@#{configatron.twitter.upload_user}\s?/,'')
            
            yum = Yum.new do |y|
              y.user          = user
              y.photo_service = photoinfo.service_name
              y.photo_url     = photoinfo.url
              y.uploaded_at   = mention['created_at']
              y.tweetable     = true
              y.text          = text
            end
            
            if yum.save
              results << yum
              Rails.cache.write(:update_check_since_id, mention['id'] )
            end
            
          end
        end
        
      end
      
      results
      
    end
    
  end
  
end
