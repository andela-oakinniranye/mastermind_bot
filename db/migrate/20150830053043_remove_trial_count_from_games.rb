class RemoveTrialCountFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :trial_count
  end
end
