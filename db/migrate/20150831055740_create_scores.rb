class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.datetime :date_played
      t.integer :time_taken
      t.integer :trial_count
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
