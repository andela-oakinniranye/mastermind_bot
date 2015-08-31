require 'rails_helper'

RSpec.describe Game, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  let(:sample_player){ {name: 'TestUser', email: 'test_user@test.com'} }
  let(:sample_game){ { time_started: Time.now, colors: 'RBGB', status: Game.statuses[:started] } }

  it 'should generate a random name at initialization' do
    player_1 = Player.create(sample_player)
    sample_game[:player] = player_1
    game = Game.create(sample_game)

    expect(game.name).to_not be(nil)
  end

  it 'does not save without a player data' do
    game = Game.create(sample_game)

    expect(game)
  end

end
