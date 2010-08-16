ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => :pages, :action => :home
  map.about "/about", :controller => :pages, :action => :about
  map.contact "/contact", :controller => :pages, :action => :contact
  map.campaign_delicam "/campaign_delicam", :controller => 'pages', :action => 'campaign_delicam'
  map.search "/search", :controller => :pages, :action => :search
  
  map.resource :help, :only => [:show], :member => {
    :biginner => :get,
    :iphone => :get,
    :report => :get,
  }
  
  map.resources :yums, :as => 'pecos', 
  :collection => {
    :recent => :get,
    :hot => :get,
    :popular => :get,
  },
  :member => {
    :vote => :put,
    :report => :put,
  } do |yums|
    yums.resources :comments, :only => [:create]
  end
  
  map.resources :users,
                :collection => {
                  :recent => :get,
                  :hot => :get,
                }
  map.resource :mypage, 
               :as => 'my', 
               :member => {:destroy_pecophoto => :delete} do |my|
                 my.resources :comments, :only => [:index], :controller => 'mypages/comments'
  end
  
  map.namespace :ajax do |ajax|
    ajax.resource :account, 
                  :member => {
                    :verify_logged_in => :get,
                    :html_user_nav => :get,
                  }
  end
  
  map.pecophoto '/:uid', :controller => :application, :action => :pecophoto_proxy, :uid => /[0-9a-zA-Z]{6,8}/
  
  map.namespace :admin do |admin|
    admin.root :controller => 'dashboards', :action => 'show'
    admin.resources :notices, :active_scaffold => true
    admin.resources :yums, :active_scaffold => true
    admin.resources :users, :active_scaffold => true
    admin.resources :comments, :active_scaffold => true
    #admin.resources :tags, :active_scaffold => true
    #admin.resources :comments, :active_scaffold => true
  end
  
end
