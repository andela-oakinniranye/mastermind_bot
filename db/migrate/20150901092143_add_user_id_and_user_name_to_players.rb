class AddUserIdAndUserNameToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :user_name, :string
    add_column :players, :user_id, :string
  end
end
