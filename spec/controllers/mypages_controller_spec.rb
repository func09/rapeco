require 'spec_helper'

describe MypagesController do

  #Delete these examples and add some real ones
  it "should use MypagesController" do
    controller.should be_an_instance_of(MypagesController)
  end


  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end
end
