class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.datetime :time_started
      t.string :color
      t.string :status
      t.references :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
