require 'spec_helper'

describe Yum do
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

