Rapeco2::Application.routes.draw do
  
  root :to => 'pages#home'
  match '/logout' => 'sessions#destroy'
  match '/about' => 'pages#about', :as => :about
  match '/contact' => 'pages#contact', :as => :contact
  match '/campaign_delicam' => 'pages#campaign_delicam', :as => :campaign_delicam
  match '/search' => 'pages#search', :as => :search
  
  resource :help do
    member do
      get :iphone
      get :report
      get :biginner
    end
  end

  resources :yums do
    collection do
      get "hot"
      get "recent"
      get "popular"
    end
    member do
      put 'vote'
      put 'report'
    end
    resources :comments, :only => [:create]
  end

  resources :users do
    collection do
      get :recent
      get :hot
    end
  end

  resource :mypage do
    resources :comments
  end

  namespace :ajax do
    resource :account do
      member do
        get :verify_logged_in
        get :html_user_nav
      end
    end
  end

  match '/:uid' => 'application#pecophoto_proxy', :as => :pecophoto, :uid => /[0-9a-zA-Z]{6,8}/

end
