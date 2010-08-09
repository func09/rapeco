require 'digest/sha1'

Factory.define :yum, :class => Yum do |f|
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

#  photo_url       :string(255)
#  photo_service   :string(255)
#  retweet_count   :integer         default(0)
#  view_count      :integer         default(0)
#  yummy_count     :integer         default(0)
#  yummy_point     :integer         default(0)
#  tweets_count    :integer         default(0)
#  not_yummy_image :boolean
#  created_at      :datetime
#  updated_at      :datetime
#  report_count    :integer         default(0)
#  uploaded_at     :datetime
#  user_id         :integer


Factory.define :tweet, :class => Tweet do |f|
  f.association :yum, :factory => :yum
  f.sequence(:status_id) {|n| n }
  f.text        "this is test tweet."
  # f.from_user ""
  # f.from_user_id 
  f.geo nil
  f.profile_image_url "hoge.png"
  f.tweeted_at { rand(5).day.ago }
end

#  yum_id            :integer         not null
#  status_id         :integer(5)      not null
#  text              :string(255)
#  from_user         :string(255)
#  from_user_id      :integer
#  geo               :string(255)
#  profile_image_url :string(255)
#  tweeted_at        :datetime
#  created_at        :datetime
#  updated_at        :datetime


Factory.define :user, :class => User do |f|
  f.sequence(:twitter_id) {|n| n }
  f.sequence(:login) {|n| "username#{n}" }
  f.access_token { Digest::SHA1.hexdigest(rand.to_s) }
  f.access_secret { Digest::SHA1.hexdigest(rand.to_s) }
end
