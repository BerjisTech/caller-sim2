# frozen_string_literal: true

class CreateRoomMessageReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :room_message_reactions do |t|
      t.string :reaction
      t.references :room_message, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
