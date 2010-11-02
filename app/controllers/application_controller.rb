# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :cache_key
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
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

  def cache_key
    @cache_key ||= request.request_uri
  end
  
  def expire_fragment_with_cache_name(cache_key)
    @tt_sweeper ||= TokyoTyrantSweeper.new('localhost','1978','rapeco')
    @tt_sweeper.sweep(cache_key)
  end
  
end
