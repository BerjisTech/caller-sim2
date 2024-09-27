# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles, id: :uuid do |t|
      t.string :user_id
      t.boolean :is_anonymous
      t.boolean :is_authenticated
      t.boolean :is_superuser
      t.boolean :is_staff
      t.string :username
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :avatar

      t.timestamps
    end
  end
end
