Rails.application.routes.draw do

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: {
        registrations: 'users/registrations'
      }
  root to: "pages#home"
  get '/start', to: 'pages#start'

  resources :itineraries, only: [:index, :show, :create, :update, :destroy] do
    patch :move
    resources :days, only: :create
    member do
      get :draft
      get :pay
      post :send_confirmation
      post :send_draft
    end
  end
  resources :items, only: :destroy
  resources :days, only: [:destroy,:update]  do
    resources :items, only: :create
  end
  resources :contents, only: :update 
    
end
