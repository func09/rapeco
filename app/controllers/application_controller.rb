class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authentication_succeeded(message = 'ログインに成功しました', destination = '/')
    flash[:notice] = message
    redirect_back_or_default destination
  end
  
  # /:uid でのアクセスをプロクシする
  def pecophoto_proxy
    redirect_to yum_url(params[:uid])
  end
  
  helper_method :impotant_notice
  def impotant_notice
    @impotant_notice ||= Notice.published.impotants.first
  end
  
end
