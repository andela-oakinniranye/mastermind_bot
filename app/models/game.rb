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
    uncompleted = []
    uncompleted += started unless started.empty?
    uncompleted += current unless current.empty?
    uncompleted
    # uncompleted += wrong_guess unless wrong_guess.empty?
  end

  alias_method :old_current!, :current!

  def current!
    self.class.where.not("id = ? OR status = ? OR status = ?", self.id, self.class.statuses[:won], self.class.statuses[:cheated]).update_all(status: self.class.statuses[:started])
    old_current!
    # self.class.where.not(id: self.id, status: self.class.statuses[:won], ).update_all(status: self.class.statuses[:started])
    # self.class.where.not(self).update_all(status: self.class.statuses[:started])
  end
end
