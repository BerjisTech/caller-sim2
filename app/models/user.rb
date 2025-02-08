# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable, :omniauthable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist, omniauth_providers: %i[google_oauth2 github]

  before_create :set_jti

 
  def self.from_omniauth(auth)
    raise ArgumentError, "Auth object is nil" if auth.nil?
    
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name || auth.info.name.split(' ').first
      user.last_name = auth.info.last_name || auth.info.name.split(' ').last
      user.skip_confirmation!
    end
  end


  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end
end
