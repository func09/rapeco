class Mypages::CommentsController < ApplicationController
  before_filter :login_required
  def index
    @comments = current_user.receive_comments.paginate(:page => params[:page], :per_page => 10)
  end

end
