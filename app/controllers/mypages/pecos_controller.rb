class Mypages::PecosController < ApplicationController
  before_filter :login_required
  def index
    @user = current_user
    @yums = @user.yums.enables.find(:all, 
      :order => 'created_at DESC').paginate(
        :page => params[:page], 
        :per_page => 15)
    @yums_group_by_date = @yums.group_by{|i| i.created_at.strftime("%Y-%m-%d")}
  end

  def show
  end

  def edit
    @yum = current_user.yums.enables.find(params[:id])
  end

end
