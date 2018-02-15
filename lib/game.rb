require './lib/request_formatter'
require 'pry'

class Game

  attr_reader :request_formatter

  def initialize(server)
    @server = server
    @request_formatter = RequestFormatter.new
    @guess = nil
    @guess_count = 0
  end

  def random_number
    rand(0..100)
  end

  def request_lines
    @server.request_from_client
  end

  def path(request_lines)
    request_formatter.path(request_lines)
  end

  def verb
    request_formatter.verb(request_lines)
  end

  def request_game_body_lines
    @server.request_from_game_client
  end

  def generate_game_body_lines
    request_game_body_lines if path(request_lines).start_with?("/game") && verb == "POST"
  end

  def guess_count_output
    "You have made #{@guess_count} guesses."
  end

  def player_guesses
    if @guess_count > 0 #use if @guess?
      response = "Your guess is too high." if @guess > random_number
      response = "Your guess is too low." if @guess < random_number
      response = "Bingo! Your guess is correct." if @guess == random_number
      response = response + "\n" + guess_count_output
    end
    response
  end

  def play_game
    #capture @guess here for the first response
    #need to SRP out the guess and continue game 
    if path(request_lines).start_with?("/game") && verb(request_lines) == "GET"
      game_response
    elsif path(request_lines).start_with?("/game") && verb(request_lines) == "POST"
      continue_game
    end
  end

  def game_response
    @server.response_from_server(player_guesses)
    #need to output player guess too if guess is not equal to random number
    "The end" if player_guesses == "Bingo! Your guess is correct.\nYou have made #{@guess_count} guesses."
  end

  def continue_game
    @guess_count += 1
    @guess_count_output = "You have made #{@guess_count} guesses."
    @guess = request_game_body_lines.last.to_i
    @server.response_from_game_server(response)
  end

  def run
    random_number
    request_lines
    @server.accept_request
    loop do
      play_game
    end
  end

end
