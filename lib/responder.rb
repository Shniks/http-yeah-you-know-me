require './lib/request_formatter'
require './lib/word_search'
require './lib/game'

class Responder

  def initialize
    @formatter = RequestFormatter.new
    @hello_count = 0
    @request_count = 0
  end

  def route(request)
    @request = request
    return route_post(request) if @formatter.verb(request) == "POST"
    return route_get(request, request_count = @request_count, hello_count = @hello_count) if @formatter.verb(request) == "GET"
  end

  def route_post(request)
    return game_response(request) if @formatter.path(request) == "/start_game"
    return @game.player_guess(@formatter.guess) if @formatter.path(@request) == "/game"
    @game = Game.new if @formatter.path(@request) == "/start_game"
  end

  def route_get(request_lines, request_count, hello_count)
    @request_count += 1
    path = @formatter.path(request_lines)
    return hello_world_response(request_lines, hello_count) if path == "/hello"
    return date_time_response(request_lines) if path == "/datetime"
    return word_search_response(request_lines) if path.start_with?\
    ("/word_search?")
    return @game.feedback if path == "/game"
    return shutdown_response(request_lines, request_count)\
     if path == "/shutdown"
    return root_response(request_lines) if path == "/"
    return "500 SystemError" if path == "/force_error"
    return "404 Not Found"
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

  def game_response(request_lines)
    root_response(request_lines) + "\n" + "Good luck!"
  end

  def shutdown_response(request_lines, request_count)
    root_response(request_lines) + "\n" + "Total requests: #{request_count}\n"
  end

end
