class CreateRoomMessageReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :room_message_reactions, id: :uuid do |t|
      t.string :reaction
      t.references :room_message, null: false, foreign_key: true, type: :uuid
      t.references :profile, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
