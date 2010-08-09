class CommentsController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => [:create]
  def create
    @comment = Comment.new params[:comment]
    @comment.user = current_user
    if @comment.save
      flash[:success] = "コメントを投稿しました"
      redirect_to yum_path(@comment.yum_id)
    else
      flash[:error] = "コメントの投稿に失敗しました"
      redirect_to yum_path(@comment.yum_id)
    end
  end
end
