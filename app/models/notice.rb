class Notice < ActiveRecord::Base
  include Pacecar
  TYPES = %w{NoticeNew NoticeMedia}
  validates_presence_of :title
  
  # 公開中
  named_scope :published, 
    :conditions => ['hidden = ? AND published_at <= ?', false, Date.today], 
    :order => 'published_at DESC, created_at DESC'
    
  # 重要
  named_scope :impotants,
    :conditions => ['impotant = ?', true]
end


# == Schema Information
#
# Table name: notices
#
#  id           :integer         not null, primary key
#  title        :string(255)     not null
#  body         :text
#  published_at :date            not null
#  hidden       :boolean         default(FALSE)
#  impotant     :boolean         default(FALSE)
#  type         :string(255)     default("NoticeNew"), not null
#  created_at   :datetime
#  updated_at   :datetime
#

