class Game < ActiveRecord::Base
  belongs_to :player
  has_one :score
  enum status: [ :started, :current, :cheated, :quitted, :ended, :won ]
  before_create :set_basic_data

  def set_basic_data
    self.name= name || SecureRandom.hex
    self.time_started = Time.now
    self.trial_count = 0
  end

  def self.saved_games
    where("status = ? OR status = ? AND trial_count <= ?", statuses[:started], statuses[:current], Mastermind::Game::ALLOWED_TRIALS)
  end

  alias_method :old_current!, :current!

  def current!
    Game.current.where(player: self.player).where.not(id: self.id).update_all(status: Game.statuses[:started])
    old_current!
  end
end
