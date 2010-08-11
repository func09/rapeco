class PagesController < ApplicationController
  def home
    @cache_key = cache_key(params.to_query, :expires_in => 1.minutes)
    unless read_fragment @cache_key
      @notices      = Notice.published.limited(3)
      @comments     = Comment.recent.limited(5)
      @hot_users    = User.hot.limited(10)
      @hot_yums     = Yum.hot.limited(6)
      @recent_yums  = Yum.recent.limited(9)
      @popular_yums = Yum.popular.limited(3)
      expire_fragment_with_cache_name(params.to_query)
    end
  end
  
  def about
  end
  
  def help
  end

end
