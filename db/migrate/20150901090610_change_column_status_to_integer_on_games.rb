class ChangeColumnStatusToIntegerOnGames < ActiveRecord::Migration
  def change
    change_column :games, :status, :integer
  end
end
