require 'spec_helper'

describe Crawler do
  
  context "クラス" do
    subject {Crawler}
    it {should respond_to(:check_upload)}
    it {should respond_to(:check_mentions)}
  end
  
  it {
    true.should be_true
  }
end
