class NoticeMedia < Notice
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

