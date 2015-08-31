class GameSerializer < ActiveModel::Serializer
  attributes :id

  # def started_game
  #   game = object.started
  #   if game.empty?
  #     game= wrong_guess
  #   end
  #   game
  # end
  #
  # def wrong_guess
  #   game = object.wrong_guess
  # end
end
