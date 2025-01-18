# frozen_string_literal: true

# app/controllers/users/omniauth_callbacks_controller.rb
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    respond_to :json

    def google_oauth2
      handle_auth('Google')
    end

    def github
      handle_auth('Github')
    end

    def passthru
      # This method is used to trigger OmniAuth's authentication flow
      # The actual redirection is handled by OmniAuth middleware
      render status: 404, json: {
        status: { message: "Not found. Authentication passthru." }
      }
    end

    private

    def handle_auth(kind)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in @user
        render json: {
          status: { code: 200, message: "Signed in successfully with #{kind}." },
          data: UserSerializer.new(@user).serializable_hash[:data][:attributes],
          token: current_token
        }
      else
        render json: {
          status: { message: "Authentication failed. #{@user.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end

    def current_token
      request.env['warden-jwt_auth.token']
    end

    def failure
      render json: {
        status: { message: 'Authentication failed.' }
      }, status: :unauthorized
    end

    # Optional: Add error handling for OmniAuth failures
    def after_omniauth_failure_path_for(scope)
      failure_path
    end
  end
end
