require './lib/request_formatter'
require './lib/word_search'
require './lib/server'
require './lib/game'
require 'pry'

class Responder

  def initialize
    @formatter = RequestFormatter.new
    @hello_count = 0
    @request_count = 0
    @game_running = false
  end

  def route(request, client = 0)
    @request = request
    return route_post(request, client) if @formatter.verb(request) == "POST"
    return route_get(request, request_count = @request_count,
       hello_count = @hello_count) if @formatter.verb(request) == "GET"
  end

  def route_post(request, client)
    return start_game if @formatter.path(request) == "/start_game"
    return play_game(request, client) if @formatter.path(request).include?("/game")
    return not_found
  end

  def route_get(request_lines, request_count, hello_count)
    @request_count += 1
    path = @formatter.path(request_lines)
    return hello_world_response(request_lines, hello_count) if path == "/hello"
    return date_time_response(request_lines) if path == "/datetime"
    return word_search_response(request_lines) if path.start_with?\
    ("/word_search?")
    return game if path == "/game"
    return shutdown_response(request_lines, request_count)\
     if path == "/shutdown"
    return root_response(request_lines) if path == "/"
    return force_error if path == "/force_error"
    return not_found
  end

  def root_response(request_lines)
    @formatter.request_full_output(request_lines)
  end

  def hello_world_response(request_lines, hello_count)
    @hello_count += 1
    root_response(request_lines) + "\n" + "Hello World! (#{hello_count})"
  end

  def date_time_response(request_lines)
    root_response(request_lines) + "\n" +\
    Time.now.strftime('%H:%M%p on %A, %B %d, %Y')
  end

  def word_search_response(request_lines)
    root_response(request_lines) + "\n" +\
    WordSearch.new.word_search_response(request_lines)
  end

  def shutdown_response(request_lines, request_count)
    root_response(request_lines) + "\n" + "Total requests: #{request_count}\n"
  end

  def not_found
    "404 Not Found"
  end

  def force_error
    "500 SystemError"
  end

  def start_game
    if @game_running == true
      response = "Game in progress!"
    else
      @game = Game.new
      @game_running = true
      response = "Good luck!"
    end
    response
  end

  def game
    if @game_running == true
      response = @game.feedback
    else
      response = "No game in progress!"
    end
    response
  end

  def play_game(request, client)
    if @game_running == true
      guess = read_guess(request, client)
      response = @game.player_guess(guess)
    else
      response = "No game in progress!"
    end
    response
  end

  def read_guess(request, client)
    body = client.read(@formatter.request_content_length(request))
    @formatter.user_guess(body)
  end

end
