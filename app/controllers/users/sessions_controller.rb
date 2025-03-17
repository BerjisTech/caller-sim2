# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
    include RackSessionsFix
    respond_to :json
    before_action :configure_sign_in_params, only: [:create]

    private

    # def create
    #   self.resource = warden.authenticate!(auth_options)
    #   sign_in(resource_name, resource)
    #   token = JsonWebToken.encode(sub: resource.id)

    #   render json: {
    #     status: {
    #       code: 200,
    #       message: 'Logged in successfully.',
    #       data: { 
    #         user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
    #         token: token
    #       }
    #     }
    #   }, status: :ok
    # end

    def respond_with(current_user, _opts = {})
      token = JsonWebToken.encode(sub: current_user.id)
      response.set_header('Authorization', token)

      render json: {
        status: {
          code: 200, message: 'Logged in successfully.',
          data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes], token: token }
        }
      }, status: :ok
    end

    # app/controllers/users/sessions_controller.rb
    def respond_to_on_destroy
      current_user = nil
      jwt_payload = nil

      token = request.headers['Authorization']&.split(' ')&.last

      begin
        jwt_payload = JWT.decode(
          token,
          Rails.application.credentials.devise_jwt_secret_key!
        ).first if token
        
        current_user = User.find(jwt_payload['sub']) if jwt_payload
        current_user&.invalidate_jwt(token) # Add token to denylist
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
        Rails.logger.error "Logout error: #{e.message}"
      end
    
      if current_user
        render json: { status: 200, message: 'Logged out successfully.' }
      else
        render json: { 
          status: 401,
          message: "Couldn't find an active session." 
        }, status: :unauthorized
      end
    end

    protected
    # Permit the email and password parameters for sign in
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    end
  end
end
