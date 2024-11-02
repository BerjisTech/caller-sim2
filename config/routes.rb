# frozen_string_literal: true

Rails.application.routes.draw do
  get "home/index"
  get "home/about"
  get "home/contact"
  get "home/faq"
  get "home/terms"
  get "home/support"
  get "home/privacy"

  root to: "home#index"

  devise_for :users, path: "", path_names: {
                                 sign_in: "login",
                                 sign_out: "logout",
                                 registration: "signup"
                               },
                     controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations"
                     }

  resources :profiles, only: %i[index show create update destroy]
  resources :rooms, only: %i[index create show] do
    member do
      patch :update_room
      get :members
      get :messages
      get "messages/:message_id/reactions", to: "rooms#message_reactions", as: :message_reactions
      post :add_member
    end

    collection do
      get :tags, action: :room_by_tags
      get :active, action: :active_rooms
    end
  end

  resources :media_streams
end
