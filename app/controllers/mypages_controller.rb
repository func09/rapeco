class MypagesController < ApplicationController
  
  before_filter :login_required
  
  @@per_page = 3 * 5
  
  def show
    @user = current_user
    @yums = @user.yums.enables.find(:all, :order => 'created_at DESC').paginate(:page => params[:page], :per_page => @@per_page)
    @yums_group_by_date = @yums.group_by{|i| i.created_at.strftime("%Y-%m-%d")}
  end
  
  def destroy_pecophoto
    yum = current_user.yums.find(params[:yum_id])
    yum.not_yummy_image = true
    yum.save!
    flash[:notice] = "ペコフォトを削除しました"
    redirect_to :action => :show
  end
  
end
