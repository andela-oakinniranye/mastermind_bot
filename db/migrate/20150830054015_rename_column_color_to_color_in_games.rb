class RenameColumnColorToColorInGames < ActiveRecord::Migration
  def change
    rename_column :games, :color, :colors
  end
end
