# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  get 'home/about'
  get 'home/contact'
  get 'home/faq'
  get 'home/terms'
  get 'home/support'
  get 'home/privacy'

  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  resources :rooms, only: %i[index create] do
    member do
      get :room
      patch :update_room
      get :members
      get :messages
      get 'messages/:message_id/reactions', to: 'rooms#message_reactions', as: :message_reactions
      post :add_member
    end

    collection do
      get :room_by_tags
    end
  end

  resources :media_streams
end
