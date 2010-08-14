class UsersController < ApplicationController
  @@per_page = 3 * 5
  
  def index
    @cache_key = params.to_query
    unless read_fragment @cache_key
      @users = User.recent.paginate(
        :page => params[:page], 
        :per_page => @@per_page)
      render :action => 'recent'
    end
  end
  
  def recent
    @cache_key = params.to_query
    unless read_fragment @cache_key
      @users = User.recent.paginate(
        :page => params[:page], 
        :per_page => @@per_page)
    end
  end
  
  def hot
    @cache_key = params.to_query
    unless read_fragment @cache_key
      @users = User.hot.paginate(
        :page => params[:page],
        :per_page => @@per_page)
    end
  end
  
  def show
    @cache_key = params.to_query
    unless read_fragment @cache_key
      @user = User.find(params[:id])
      @yums = @user.yums.enables.find(
        :all, 
        :order => 'created_at DESC').paginate(
          :page => params[:page], 
          :per_page => 15)
    end
  end
  
end
