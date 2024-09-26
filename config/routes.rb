# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  get 'home/about'
  get 'home/contact'
  get 'home/faq'
  get 'home/terms'
  get 'home/support'
  get 'home/privacy'
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Make /api to be root
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  resources :rooms do
    resources :room_members
    resources :room_messages do
      resources :room_message_reactions
    end
  end
  resources :media_streams
end
