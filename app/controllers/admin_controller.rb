class AdminController < ApplicationController
  
  layout 'admin'
  before_filter :authenticate
  
  def hidden_yum
    yum = Yum.find(params[:yum_id])
    yum.not_yummy_image = true
    yum.save!
    flash[:notice] = "画像を非表示にしました"
    redirect_to :action => :show
  end
  
  private
    
    def authenticate
      authenticate_or_request_with_http_basic do |user_name, password|
        user_name == configatron.admin.username && password == configatron.admin.password
      end
    end


end
