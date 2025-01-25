# frozen_string_literal: true

# config/initializers/omniauth.rb
require 'omniauth-google-oauth2'
require 'omniauth-github'

# Configure OmniAuth logging
OmniAuth.config.logger = Rails.logger
OmniAuth.config.allowed_request_methods = %i[post get]
OmniAuth.config.silence_get_warning = true

# Optional: Add state validation (recommended for security)
OmniAuth.config.before_request_phase do |env|
  state = SecureRandom.hex(24)
  env['rack.session']['omniauth.state'] = state
  Rails.logger.info "OmniAuth state set: #{state}"
end

# Configure providers
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 
           ENV['GOOGLE_CLIENT_ID'], 
           ENV['GOOGLE_CLIENT_SECRET'],
           {
            scope: 'email,profile',
            prompt: 'select_account',
            access_type: 'online',
            name: 'google',
            callback_url: "#{ENV['API_URL']}/auth/google_oauth2/callback",
          }

  provider :github, 
          ENV['GITHUB_CLIENT_ID'], 
          ENV['GITHUB_CLIENT_SECRET'],
          {
            scope: 'user:email',
            name: 'github',
            callback_url: "#{ENV['API_URL']}/auth/github/callback",
        }
end

# Log OmniAuth configuration
Rails.logger.info "OmniAuth configured with Google OAuth2 and GitHub providers."