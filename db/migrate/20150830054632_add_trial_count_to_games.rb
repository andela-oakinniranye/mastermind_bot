class AddTrialCountToGames < ActiveRecord::Migration
  def change
    add_column :games, :trial_count, :integer
  end
end
