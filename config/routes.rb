Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    # namespace :admin do
    #   resources :users
    #   resources :bookings
    #   resources :reviews
    #   resources :venues

    #   root to: "users#index"
    # end
  root to: 'pages#home', as: 'root'

  devise_for :users

  resources :venues
  resources :bookings do
    resources :reviews, only: %i[new create]
  end

  resources :membership

  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'
end
