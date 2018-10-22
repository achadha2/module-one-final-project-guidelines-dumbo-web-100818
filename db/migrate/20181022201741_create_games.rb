class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :player_one_id
      t.integer :player_two_id
      t.integer :board_id
      t.integer :winner_id
      t.string  :status
      t.timestamps
    end
  end
end
