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
        status: { message: 'Not found. Authentication passthru.' }
      }
    end

    private

    def handle_auth(kind)
      Rails.logger.info "Request ENV: #{request.env.inspect}"
      auth = request.env['omniauth.auth']
      Rails.logger.info "OmniAuth Auth Object: #{auth.inspect}"
    
      if auth.nil?
        Rails.logger.error "OmniAuth authentication failed: Auth object is nil"
        render json: {
          status: { message: "Authentication failed. No data received from #{kind}." }
        }, status: :unprocessable_entity
        return
      end
    
      @user = User.from_omniauth(auth)
    
      begin
        @user = User.from_omniauth(auth)
        
        if @user.persisted?
          # Generate JWT token
          token = JsonWebToken.encode(sub: @user.id)

          sign_in @user

          # Prepare payload for popup callback
          payload = {
            status: {
              code: 200,
              message: "Signed in successfully with #{kind}."
            },
            data: UserSerializer.new(@user).serializable_hash[:data][:attributes],
            token: token
          }

          # Render JavaScript to post message to opener window and close popup
          html = <<-HTML
            <!DOCTYPE html>
            <html>
            <head><meta charset="utf-8"><title>Authentication successful</title></head>
            <body>
              <script type="text/javascript">
                (function() {
                  window.opener.postMessage({ type: 'oauth-response', response: #{payload.to_json} }, '*');
                  window.close();
                })();
              </script>
            </body>
            </html>
          HTML

          render html: html.html_safe
        else
          Rails.logger.error "Failed to persist user: #{@user.errors.full_messages}"
          render json: {
            status: { message: "Failed to create user account. #{@user.errors.full_messages.join(', ')}" }
          }, status: :unprocessable_entity
        end
      rescue => e
        Rails.logger.error "Error in #{kind} OAuth: #{e.message}\n#{e.backtrace.join("\n")}"
        render json: {
          status: { message: "Authentication error occurred." }
        }, status: :internal_server_error
      end
    end

    def failure
      Rails.logger.error "OmniAuth authentication failed: #{params[:message]}"
      render json: {
        status: { message: 'Authentication failed.' }
      }, status: :unauthorized
    end

    def current_token
      request.env['warden-jwt_auth.token']
    end

    # Optional: Add error handling for OmniAuth failures
    def after_omniauth_failure_path_for(_scope)
      failure_path
    end
  end
end
