# frozen_string_literal: true

# db/migrate/YYYYMMDDHHMMSS_add_omniauth_to_users.rb
class AddOmniauthToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_index :users, %i[provider uid], unique: true
  end
end
