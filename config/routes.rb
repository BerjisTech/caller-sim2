# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  get 'home/about'
  get 'home/contact'
  get 'home/faq'
  get 'home/terms'
  get 'home/support'
  get 'home/privacy'

  root to: 'home#index'

  devise_for :users, 
    path: '', 
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      omniauth_callbacks: 'users/omniauth_callbacks'
    },
    defaults: { format: :json },
    skip: [:omniauth_callbacks] 

    # Add this devise_scope block
    devise_scope :user do
      # Initial OAuth routes
      get '/auth/google_oauth2', to: 'users/omniauth_callbacks#google_oauth2', as: :user_google_oauth2_omniauth_authorize
      get '/auth/github', to: 'users/omniauth_callbacks#github', as: :user_github_omniauth_authorize
      
      # Callback routes
      get '/auth/google_oauth2/callback', to: 'users/omniauth_callbacks#google_oauth2', as: :user_google_oauth2_omniauth_callback
      get '/auth/github/callback', to: 'users/omniauth_callbacks#github', as: :user_github_omniauth_callback
      
      # Failure route
      get '/auth/failure', to: 'users/omniauth_callbacks#failure'
    end
    
  resources :profiles, only: %i[index show create update destroy]
  resources :rooms, only: %i[index create show] do
    member do
      patch :update_room
      put :update_room # Add this line for PUT requests
      get :members
      get :messages
      get 'messages/:message_id/reactions', to: 'rooms#message_reactions', as: :message_reactions
      post :add_member
    end

    collection do
      get :tags, action: :room_by_tags
      get :active, action: :active_rooms
    end
  end

  resources :media_streams
end
