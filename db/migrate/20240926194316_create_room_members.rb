# frozen_string_literal: true

class CreateRoomMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :room_members, id: :uuid do |t|
      t.boolean :is_admin
      t.references :room, null: false, foreign_key: true, type: :uuid
      t.references :profile, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
