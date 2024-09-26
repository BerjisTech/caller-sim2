class CreateRoomMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :room_messages, id: :uuid do |t|
      t.text :content
      t.boolean :is_edited
      t.boolean :is_deleted
      t.references :room, null: false, foreign_key: true, type: :uuid
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.integer :reply_to_id
      t.integer :quoted_message_id

      t.timestamps
    end
  end
end
