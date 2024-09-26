class CreateMediaStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :media_streams, id: :uuid do |t|
      t.text :stream_data
      t.references :profile, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
