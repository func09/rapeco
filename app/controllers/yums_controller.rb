class YumsController < ApplicationController
  
  before_filter :login_required, :only => [:new, :create]
  skip_before_filter :verify_authenticity_token, :only => [:vote, :report]
  
  @@per_page = 10
  
  def new
    @yum = Yum.new
  end
  
  def create
    yum = current_user.yums.build params[:yum]
    if yum.save
      logger.info "投稿に成功しました #{yum}"
      flash[:notice] = "ペコフォトの投稿に成功しました"
      redirect_to yum_path(yum)
    else
      logger.error yum.errors.inspect
      logger.error("投稿に失敗しました")
      flash[:error] = "ペコフォトの投稿に失敗しました、しばらく経ってからもう一度お試しください。"
      render :action => :new
    end
  end
  
  def index
    @cache_key = cache_key(params.to_query, :expires_in => 1.minutes)
    unless read_fragment @cache_key
      @yums = Yum.search(:all, params[:tag]).paginate(
        :page => params[:page],
        :per_page => @@per_page)
      expire_fragment_with_cache_name(params.to_query)
    end
  end
  
  def recent
    @cache_key = cache_key(params.to_query, :expires_in => 1.minutes)
    @mode = :recent
    unless read_fragment @cache_key
      @yums = Yum.search(:recent, params[:tag]).paginate(
        :page => params[:page],
        :per_page => @@per_page)
      expire_fragment_with_cache_name(params.to_query)
    end
    render :action => :index
  end
  
  def hot
    @cache_key = cache_key(params.to_query, :expires_in => 1.minutes)
    unless read_fragment @cache_key
      @yums = Yum.search(:hot, params[:tag]).paginate(
        :page => params[:page],
        :per_page => @@per_page)
      expire_fragment_with_cache_name(params.to_query)
    end
    render :action => :index
  end
  
  def popular
    @h1 = "人気ペコフォト"
    @cache_key = cache_key(params.to_query, :expires_in => 1.minutes)
    unless read_fragment @cache_key
      @yums = Yum.search(:popular, params[:tag]).find(
        :all, 
        :limit => 100).paginate(
          :page => params[:page], 
          :per_page => @@per_page)
      expire_fragment_with_cache_name(params.to_query)
    end
    render :action => :index
  end
  
  def show
    @cache_key = cache_key(params.to_query, :expires_in => 1.minutes )
    @yum = Yum.enables.find(params[:id])
    # ビューカウント
    view_count_increment(@yum)
    unless read_fragment @cache_key
      expire_fragment_with_cache_name(params.to_query)
    end
  end
  
  def vote
    
    @yum = Yum.find(params[:id])
    
    # Cookieから投票カウントを取得する
    vote_counts = cookies[:vote_counts] ? YAML.load(cookies[:vote_counts]) : {}
    vote_counts[@yum.uid] = 0 unless vote_counts[@yum.uid]
    
    # 投票回数が5回以下であるか
    if vote_counts[@yum.uid] <= 5
      if @yum.vote!
        
        # カウントアップ
        vote_counts[@yum.uid] += 1
        # Cookie保存
        cookies[:vote_counts] = {
          :value => vote_counts.to_yaml,
          :expires => 1.month.from_now,
        }
        
        logger.info "vote count: #{@yum.uid} -> #{vote_counts[@yum.uid]}"
        flash[:notice] = "このペコフォトにペコペコ投票しました"
        redirect_to :action => :show
      else
        flash[:error] = "ペコペコ投票しましたに失敗しました。申し訳ありませんが、しばらく経ってからもう一度お試しください。"
        redirect_to :action => :show
      end
    else
      # 5回以上投票している
      flash[:error] = "申し訳ありませんが、ひとつのペコフォトにつきペコペコ投票は5回までとなっています"
      redirect_to :action => :show
    end
    
  end
  
  def report
    @yum = Yum.find(params[:id])
    if @yum.report!
      flash[:notice] = "この写真に写っているものが食べられないことを報告しました"
      redirect_to :action => :show
    else
      flash[:error] = "写真の報告に失敗しました"
      redirect_to :action => :show
    end
  end
  
  private
    
    # 自分のペコフォトであるか？
    def mypecophoto?(yum)
      logged_in? && current_user == yum.user
    end
    
    def view_count_increment(yum)
      unless mypecophoto?(yum)
        yum.view!
      end
    end
    
end
