module YumsHelper
  
  include ActsAsTaggableOn::TagsHelper
  
  def link_to_retweet(title,yum)
    if yum.user
      message = "ハラペコなう！ RT @#{yum.user.login} #{pecophoto_url(yum.uid)} #rapeco"
    else
      message = "ハラペコなう！ #{pecophoto_url(yum.uid)} #rapeco"
    end
    link = "http://twitter.com/?status=#{URI.escape(message)}"
    link_to title, link, :target => '_blank'
  end
  
  def text_without_photolink(tweet, photo_url)
    h tweet.text.gsub(/#{photo_url}/,'')
  end
  
  def for_title(text = "")
    text.gsub!(/http:\/\/[0-9a-zA-Z.?-_:\/]+/,'') # URL削除
    text.gsub!(/@[0-9a-zA-Z_]+:?/,'') # ユーザー名削除
    text.gsub!(/RT|QT/,'') # RT QT削除
    text.gsub!(/#[0-9a-zA-Z\-_]+/,'') # ハッシュタグ削除
    text.gsub!(/\s{2}/,'')
    if text.blank?
      text = 'no title'
    end
    truncate(text, 25)
  end
  
  def link_to_hatebu(yum)
    # url = "#{configatron.host}/pe#{@yum.uid}"
    url = yum_url(@yum)
    image = %Q{<img src="http://d.hatena.ne.jp/images/b_entry.gif" width="16" height="12" style="border: none;" alt="このエントリーを含むはてなブックマーク" title="このエントリーを含むはてなブックマーク" /> <img src="http://b.hatena.ne.jp/entry/image/#{url}">}
    link_to image, "http://b.hatena.ne.jp/entry/#{url}"
  end
  
end
