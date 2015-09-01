class Api::V1::MastermindsController < ApplicationController
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
    else invalid_command
    end
  end

  def index
    render json: mastermind_main.response
  end

  def invalid_command
    game = mastermind_game
    message = "You entered an unsupported game action/command.\nSupported actions include: [ (p)lay | (g)uess| select | (q)uit | (b)ackground | (i)nstructions ]\n"
    message += <<-EOS
      send ```play``` to start the game
      send ```guess (guess) e.g. 'guess RGBY' to guess (r)ed, (g)reen, (b)lue, (y)ellow```
      send ```select (game_id) e.g. 'select u989hnjh989ihiu9u909'
      send ```quit``` to quit the game
      send ```instructions``` to view the game-play instructions
      send ```background``` to view the background of Mastermind
    EOS
    game.response.unsupported_game_action(message: message, status: :unknown)
    render json: game.response
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
    game = mastermind_game
    game.load_game(game_record)

    save_record = game.guess(guessed_color)
    game_record.update_attributes(trial_count: game.trial_count)
    response = game.response
    response2 = mastermind_game.response.trial_count(game.trial_count, game.colors.join, game.color_values_from_all_colors_array)
    set_game_as_won(game_record, save_record) if response.status == :won
    response.append_message(response2) unless response.status == :won
    set_game_as_lost(game_record) if response.status == :lost
    render json: response
  end

  def set_game_attr

  end

  def set_game_as_won(game_record, save_record)
    score = Score.create(save_record)
    game_record.score = score
    game_record.won!
  end

  def set_game_as_lost(game_record)
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
