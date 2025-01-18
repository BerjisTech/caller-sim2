# config/initializers/omniauth.rb
require 'omniauth-google-oauth2'
require 'omniauth-github'

OmniAuth.config.logger = Rails.logger
OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true

# Optional: Add state validation (recommended for security)
OmniAuth.config.before_request_phase do |env|
  env['rack.session']['omniauth.state'] = SecureRandom.hex(24)
end