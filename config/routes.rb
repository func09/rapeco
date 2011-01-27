Rapeco2::Application.routes.draw do
  
  root :to => 'pages#home'
  match '/logout' => 'sessions#destroy'
  match '/about' => 'pages#about',                        :as => :about
  match '/contact' => 'pages#contact',                    :as => :contact
  match '/campaign_delicam' => 'pages#campaign_delicam',  :as => :campaign_delicam
  match '/search' => 'pages#search',                      :as => :search
  
  resource :help do
    get :iphone,    :on => :member
    get :report,    :on => :member
    get :biginner,  :on => :member
  end

  resources :yums, :path => '/pecos' do
    get "hot",      :on => :collection
    get "recent",   :on => :collection
    get "popular",  :on => :collection
    put 'vote',     :on => :member
    put 'report',   :on => :member
    resources :comments, :only => [:create]
  end

  resources :users do
    get :recent,    :on => :collection
    get :hot,       :on => :collection
  end

  resource :mypage, :path => '/my' do
    delete 'destroy_pecophoto', :on => :member
    resources :comments, :only => [:index], :controller => 'mypages/comments'
  end

  namespace :ajax do
    resource :account do
      get :verify_logged_in, :on => :member
      get :html_user_nav, :on => :member
    end
  end

  match '/:uid' => redirect("/pecos/%{uid}"), :constraints => {:uid => /[0-9a-zA-Z]{6,8}/}, :as => :pecophoto
  

end
