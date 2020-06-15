Rails.application.routes.draw do
  get 'users/show'
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

  mount StripeEvent::Engine, at: '/stripe-webhooks'

  devise_for :users, :path_prefix => 'd', controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
  }
  # API for fetching venues from front-end!
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :venues, only: [ :index, :show ]
    end
  end

  resources :users, only: [:show]

  resources :venues

  resources :bookings do 
    resources :reviews, only: %i[new create]
    resources :payments, only: :new
  end

  resources :membership

  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'
end
