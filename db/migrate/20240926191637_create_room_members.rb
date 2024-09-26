# frozen_string_literal: true

class CreateRoomMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :room_members do |t|
      t.boolean :is_admin
      t.references :room, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
