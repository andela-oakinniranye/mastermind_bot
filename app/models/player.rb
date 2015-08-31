class Player < ActiveRecord::Base
  belongs_to :organization
  has_many :games
  has_many :scores, through: :games
end
