Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :itineraries, only: [:index, :show, :create, :update] do
    resources :days, only: :create
    member do
      get :draft
      get :pay
      post :send_confirmation
      post :send_draft
    end
  end
  resources :items, only: :destroy
  resources :days, only: :destroy do
    resources :items, only: :create
  end
end
