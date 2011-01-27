require 'digest/sha1'

Factory.define :yum do |f|
  f.photo_url     "http://twitpic/abcdef"
  f.photo_service "twitpic"
  f.retweet_count 0
  f.view_count    0
  f.yummy_count   0
  f.yummy_point   0
  f.tweets_count  0
  f.not_yummy_image nil
  f.report_count  0
  f.uploaded_at { rand(5).day.ago }
  f.user_id nil
end

Factory.define :user do |f|
  f.sequence(:twitter_id) {|n| n }
  f.sequence(:login) {|n| "username#{n}" }
  f.access_token { Digest::SHA1.hexdigest(rand.to_s) }
  f.access_secret { Digest::SHA1.hexdigest(rand.to_s) }
end
