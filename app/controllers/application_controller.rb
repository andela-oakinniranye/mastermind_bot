class ApplicationController < ActionController::API
  include ActionController::Serialization

  private
    def mastermind_main
      Mastermind::Main.new
    end

    def mastermind_game
      message = Mastermind::Message.new
      game = Mastermind::Game.new(message)

      game
    end

    def current_player
      player = Player.find_or_create_by(required_params)
      player
    end

    def required_params
      params.permit(:email, :name, :user_id, :user_name)
    end
end
