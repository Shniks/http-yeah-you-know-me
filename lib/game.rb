class Game

  attr_reader :guess_count,
              :guess

  def initialize
    @guess_count = 0
    @random = rand(0..100)
  end

  def player_guess(guess)
    @guess_count += 1
    @guess = guess.to_i
    game_response
    feedback
  end

  def game_response
    response = "too high." if @guess > @random
    response = "too low." if @guess < @random
    response = "correct." if @guess == @random
    response
  end

  def feedback
    ["Total number of guesses made: #{@guess_count}.",
    "Your most recent guess of #{@guess} is #{game_response}"].join("\n")
  end

end
