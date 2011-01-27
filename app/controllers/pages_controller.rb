class PagesController < ApplicationController
  def home
    unless read_fragment @cache_key
      @notices      = Notice.published.limit(3)
      @comments     = Comment.recent.limit(5)
      @hot_users    = User.hot.limit(10)
      @hot_yums     = Yum.hot.limit(6)
      @recent_yums  = Yum.recent.limit(9)
      @popular_yums = Yum.popular.limit(3)
    end
  end
  
  def about
  end
  
  def help
  end

end
