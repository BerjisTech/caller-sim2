# frozen_string_literal: true

class CreateMediaStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :media_streams do |t|
      t.text :stream_data
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
