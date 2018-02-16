require './lib/game'
require_relative 'test_helper'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_if_it_exists
    assert_instance_of Game, @game
  end

  def test_it_can_generate_a_random_number_between_0_and_100
    assert @game.random_number.between?(0, 100)
  end

  def test_it_can_capture_player_guess
    user_guess = 33
    @game.player_guess(user_guess)

    assert_equal 33, @game.guess
  end

  def test_it_can_capture_player_guess_that_is_a_string
    user_guess = "19"
    @game.player_guess(user_guess)

    assert_equal 19, @game.guess
  end

  def test_it_starts_with_zero_guesses
    assert_equal 0, @game.guess_count
  end

  def test_it_can_count_one_guess
    @game.player_guess(2)

    assert_equal 1, @game.guess_count
  end

  def test_it_can_count_multiple_guesses
    35.times do
      user_guess = rand(0..100)
      @game.player_guess(user_guess)
    end

    assert_equal 35, @game.guess_count
  end

  def test_it_can_send_too_high_game_response
    @game.random_number(50)
    @game.player_guess(68)
    expected = "too high."

    assert_equal expected, @game.game_response
  end

  def test_it_can_send_too_low_game_response
    @game.random_number(50)
    @game.player_guess(38)
    expected = "too low."

    assert_equal expected, @game.game_response
  end

  def test_it_can_send_correct_game_response
    @game.random_number(50)
    @game.player_guess(50)
    expected = "correct."

    assert_equal expected, @game.game_response
  end

  def test_it_can_give_feedback_for_one_guess
    @game.random_number(50)
    @game.player_guess(65)
    expected = "1\nYour most recent guess of 65 is too high."

    assert @game.feedback.include?(expected)
  end

  def test_it_can_give_feedback_for_three_guesses
    @game.random_number(50)
    @game.player_guess(13)
    @game.player_guess(77)
    @game.player_guess(33)
    expected = "3\nYour most recent guess of 33 is too low."

    assert @game.feedback.include?(expected)
  end

  def test_it_can_give_feedback_for_five_guesses
    @game.random_number(35)
    @game.player_guess(13)
    @game.player_guess(77)
    @game.player_guess(88)
    @game.player_guess(22)
    @game.player_guess(35)
    expected = "5\nYour most recent guess of 35 is correct."

    assert @game.feedback.include?(expected)
  end

end
