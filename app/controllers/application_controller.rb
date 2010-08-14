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

  # @param [Integer] options[:expires_in] sec
  def cache_key(name, options = {})
    cache_key = nil
    if options[:expires_in]
      ts = Time.zone.now.to_i / options[:expires_in].to_i
      cache_key = "#{name}+#{ts}"
    else
      cache_key = name
    end
  end
  
end
