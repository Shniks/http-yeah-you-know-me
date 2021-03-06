class Game

  attr_reader :random_number,
              :guess_count,
              :guess

  def initialize(random = rand(0..100))
    @guess_count = 0
    @random_number = random
  end

  def player_guess(guess)
    @guess_count += 1
    @guess = guess.to_i
    game_response
    feedback
  end

  def game_response
    return "too high." if @guess > @random_number
    return "too low." if @guess < @random_number
    return "correct." if @guess == @random_number
  end

  def feedback
    ["Total number of guesses made: #{@guess_count}.",
    "Your most recent guess of #{@guess} is #{game_response}"].join("\n")
  end

end
