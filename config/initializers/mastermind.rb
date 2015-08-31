module Mastermind
  Helper.module_eval do

  end

  Message.class_eval do
    def multiple_games_record(games)
      number_of_games = games.length
      message = "You have #{number_of_games.humanize + ' game'.pluralize(number_of_games)} saved.\nSelect the one you want to play by posting ```select (id)``` with the #{'ids'.pluralize(number_of_games)} provided below:\n"
      games.each{|game|
        remaining_trials = Game::ALLOWED_TRIALS - game.trial_count
        message += "id: #{game.name}, started #{game.time_started.strftime('%-d-%B, %Y')} and you have #{remaining_trials}  #{'trial'.pluralize(remaining_trials)} remaining. Send ```select #{game.name}``` to continue\n"
      }
      message += "Enter ```select new``` to start a new game"
      set_attr(message: message, status: :multiple_record)
    end

    def append_message(response)
      @message += "\n" + response.message
      set_attr(message: @message, status: response.status)
    end

  end

  Game.class_eval do
    attr_reader :color_values_from_all_colors_array

    def get_player(player)
      @player = Player.new
      @player.set_attr(name: player.name)
    end

    def load_current_game(colors, guess, trial_count, time_started)
      @colors = colors
      @trial_count = trial_count
      @time_started = time_started
      @character_count = @colors.length
      @guess = guess
    end

    def load_game(game)
      @colors = game.colors
      @trial_count = game.trial_count
      @time_started = game.time_started
      @character_count = @colors.length
      shuffle_colors_hash
    end

    def guess(guessed_color)
      return if the_input_is_too_long_or_too_short?(guessed_color)
      @trial_count += 1
      analyzed = analyze_guess(guessed_color)
      return won(@time_started) if check_correct?(analyzed)
      @response.analyzed_guess(analyzed[:match_position], analyzed[:almost_match])
    end

    # def update_game_record
    #
    # end

    def won(start_time)
      @time_taken = Time.now.to_i - start_time
      time = {}
      time[:mins] = @time_taken/60
      time[:secs] = @time_taken%60

      @response.won(@trial_count, time)
      return generate_save_record
    end

    def generate_save_record
      record = {trial_count: @trial_count, time_taken: @time_taken, date_played: Date.today}
      record
    end

    def instructions
      @response.instructions(@color_values_from_all_colors_array)
    end
  end

end


String.class_eval do
  def colorize(color)
    self
  end
end
