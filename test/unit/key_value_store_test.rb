require 'test_helper'

class KeyValueStoreTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: key_value_stores
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  data       :text
#  created_at :datetime
#  updated_at :datetime
#

