Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "sessions#new"

  get 'signup', to: 'users#new', as: 'new_user'
  post 'signup', to: 'users#create', as: 'users'

  get 'login', to: 'sessions#new', as: 'new_session'
  post 'login', to: 'sessions#create', as: 'session'
  post 'logout', to: 'sessions#destroy', as: 'logout'

  get 'dashboard', to: 'dashboard#show'
  get 'analytics', to: 'analytics#index'

  resources :expense_categories
  resources :currencies
  resources :tenants
  resources :user_budgets
  resources :expenses

  namespace :api do
    resources :currencies, only: [:index, :show, :create, :update, :destroy]
    resources :expense_categories, only: [:index, :show, :create, :update, :destroy]

    resources :tenants, only: [:index, :show, :create, :update, :destroy]
    resources :user_budgets, only: [:index, :show, :create, :update, :destroy]
    resources :expenses, only: [:index, :show, :create, :update, :destroy]

    post '/login', to: 'sessions#create', as: 'login'
    delete '/logout', to: 'sessions#destroy', as: 'logout'
    post '/signup', to: 'users#create', as: 'signup'

    get '/analytics', to: 'analytics#index'
  end
end
