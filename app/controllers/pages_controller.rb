class PagesController < ApplicationController
  def home
    unless read_fragment @cache_key
      @notices      = Notice.published.limited(3)
      @comments     = Comment.recent.limited(5)
      @hot_users    = User.hot.limited(10)
      @hot_yums     = Yum.hot.limited(6)
      @recent_yums  = Yum.recent.limited(9)
      @popular_yums = Yum.popular.limited(3)
    end
  end
  
  def about
  end
  
  def help
  end

end
