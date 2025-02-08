class AddDefaultJtiToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :jti, -> { "gen_random_uuid()" }
  end
end
