require './lib/game'
require_relative 'test_helper'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_if_it_exists
    assert_instance_of Game, @game
  end

end
