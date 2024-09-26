# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.integer :seats
      t.boolean :is_private
      t.string :password
      t.boolean :is_active
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
