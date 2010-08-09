class KeyValueStore < ActiveRecord::Base
  
  serialize :data
  
  class << self
    
    def get(key)
      find_or_create_by_key(key.to_s).data
    end
    
    def set(key, value)
      store = find_or_create_by_key(key.to_s)
      store.update_attribute(:data, value)
    end
    
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

