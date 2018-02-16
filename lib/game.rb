class Game

  def initialize
    @guess = nil
    @guess_count = 0
  end

  def random_number
    rand(0..100)
  end

  def player_guess(guess)
    @guess = guess.to_i
    @guess_count += 1
  end

  def game_response
    response = "too high." if @guess > random_number
    response = "too low." if @guess < random_number
    response = "correct." if @guess == random_number
  end

  def feedback
    "Total number of guesses made: #{@guess_count}\nYour most recent guess\
     of #{@guess} is #{game_response}\n"
  end

end
