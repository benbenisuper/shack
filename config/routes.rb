Rails.application.routes.draw do
  require "sidekiq/web"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'pages#home', as: 'root'

  mount StripeEvent::Engine, at: '/stripe-webhooks'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }


  # API for fetching venues from front-end!
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :venues, only: [ :index, :show ]
      resources :calendars, only: [:show]
      resources :days, only: [:show]
    end
  end

  resources :users, only: [:show]

  resources :venues do
    resources :venue_specs, only: [:create]
  end

  resources :reviews, only: %i[new create]
  resources :bookings do 
    resources :payments, only: :new
  end

  resources :chat_box, only: :show do
    resources :messages, only: [:create]
  end

  resources :membership

  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => "/cable"
end
