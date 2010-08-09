class Ajax::AccountsController < ApplicationController
  
  layout false
  
  def verify_logged_in
    data = {
      :logged_in => logged_in?
    }
    render :json => data
  end
  
  def html_user_nav
  end
  
end
