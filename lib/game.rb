class Game

  def initialize
    @random_number = rand(0..100)
    @guess = nil
    @guess_count = 0
  end

  def player_guess(guess)
    @guess = guess.to_i
    @guess_count += 1
  end

  def player_guesses
    if @guess > 0
      response = "Your guess is too high." if @guess > random_number
      response = "Your guess is too low." if @guess < random_number
      response = "Bingo! Your guess is correct." if @guess == random_number
      response = response + "\n" + guess_count_output
    end
    response
  end
  
end
