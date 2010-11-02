class UsersController < ApplicationController
  @@per_page = 3 * 5
  
  def index
    unless read_fragment @cache_key, :expires_in => 1.minutes
      @users = User.recent.paginate(
        :page => params[:page], 
        :per_page => @@per_page)
      render :action => 'recent'
    end
  end
  
  def recent
    unless read_fragment @cache_key, :expires_in => 1.minutes
      @users = User.recent.paginate(
        :page => params[:page], 
        :per_page => @@per_page)
    end
  end
  
  def hot
    unless read_fragment @cache_key, :expires_in => 1.minutes
      @users = User.hot.paginate(
        :page => params[:page],
        :per_page => @@per_page)
    end
  end
  
  def show
    unless read_fragment @cache_key, :expires_in => 1.minutes
      @user = User.find(params[:id])
      @yums = @user.yums.enables.find(
        :all, 
        :order => 'created_at DESC').paginate(
          :page => params[:page], 
          :per_page => 15)
    end
  end
  
end
