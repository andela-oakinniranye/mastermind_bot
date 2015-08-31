class Api::V1::MastermindController < ApplicationController
  before_action :mastermind_main, :current_player

  def main
    request = params[:request]
    case request.strip.downcase
    when 'p', 'play' then play
    when 'q', 'quit' then quit
    when 'i', 'instructions' then instructions
    when 'b', 'background' then background
    when 'y', 'yes' then redirect_to :saved_games_api_v1_mastermind
    when /^select:(\w+)$/, /^select (\w+)$/ then select_game_to_play($1)
    when /^guess|g[:| ](\w+)$/ then guess($1)
    # else raise NoRouteMatchError
    end
  end

  def index
    render json: mastermind_main.response
  end

  def play(new_game=nil)
    unless new_game == :new
      game = current_player.games.saved_games
      return let_me_select_the_game_i_want_to_play(game) unless game.empty?
    end
      game = mastermind_game
      game.generate_colors
      game_record = current_player.games.create(colors: game.colors.join)
      game_record.current!
      render json: game.instructions
  end

  def let_me_select_the_game_i_want_to_play(games)
    render json: mastermind_game.response.multiple_games_record(games)
  end

  def select_game_to_play(saved_game_or_new)
    if saved_game_or_new.strip.downcase == 'new'
      return play(:new)
    end
    game_record = current_player.games.find_by_name(saved_game_or_new).decorate
    game = mastermind_game
    game.load_game(game_record)

    game_record.current!
    render json: game.instructions
  end

  def guess(guessed_color)
    game_record = current_player.games.current
    return play if game_record.empty?
    game_record = game_record.first.decorate
    return play if game_record.trial_count > ::Mastermind::Game::ALLOWED_TRIALS
    game = mastermind_game
    game.load_game(game_record)

    save_record = game.guess(guessed_color)
    game_record.update_attributes(trial_count: game.trial_count)
    response = game.response
    response2 = mastermind_game.response.trial_count(game.trial_count, game.colors.join, game.color_values_from_all_colors_array)
    set_game_as_won(game_record, save_record) if response.status == :won
    response.append_message(response2) unless response.status == :won
    set_game_as_lost(game, game_record) if response.status == :lost
    render json: response
  end

  def set_game_as_won(game_record, save_record)
    score = Score.create(save_record)
    game_record.score = score
    game_record.won!
  end

  def set_game_as_lost(game, game_record)
    require 'pry' ; binding.pry
    # game.response.append_message("\nYou tried, but lost.\nThe colors generated were #{game.colors.join}.\nWant to try again? (p)lay to start again or (q)uit to exit or (t)op_players to view the top ten players. ")
    game_record.ended!
  end

  def quit
    game_record = current_player.games.current
    game_record.first.quitted! unless game_record.empty?
    render json: mastermind_game.response.exit_game
  end

  def instructions
    render json: mastermind_main.response.gameplay_instructions
  end

  def background
    render json: mastermind_main.response.main_message
  end
end
