# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

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
  
  def get_cache_key(age = 60)
    timestamp = Time.zone.now.to_i / (age)
    "#{request.params.to_query}-#{timestamp}"
  end
  
  def expire_fragment_with_cache_name
    # r = Regexp.new(get_cache_key.sub(/[0-9]+$/,'.*'))
    # expire_fragment(r) 
  end
  
end
