require './lib/request_formatter'
require './lib/word_search'
require './lib/game'

class Responder

  def initialize
    @request_formatter = RequestFormatter.new
    @hello_count = 0
    @request_count = 0
  end

  def response_created(request_lines, request_count = @request_count,\
     hello_count = @hello_count)
    @request_count += 1
    path = @request_formatter.path(request_lines)
    return hello_world_response(request_lines, hello_count) if path == "/hello"
    return date_time_response(request_lines) if path == "/datetime"
    return word_search_response(request_lines) if path.start_with?\
    ("/word_search?")
    return game_response(request_lines) if path == "/start_game"
    return shutdown_response(request_lines, request_count)\
     if path == "/shutdown"
    return root_response(request_lines)
  end

  def root_response(request_lines)
    @request_formatter.request_full_output(request_lines)
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
    if @request_formatter.verb(request_lines) == "POST"
      root_response(request_lines) + "\n" + "Good luck!"
    else
      root_response(request_lines)
    end
  end

  def shutdown_response(request_lines, request_count)
    root_response(request_lines) + "\n" + "Total requests: #{request_count}"
  end

end
