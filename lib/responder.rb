require './lib/request_formatter'
require './lib/word_search'
require './lib/game'

class Responder

  def initialize
    @request_formatter = RequestFormatter.new
  end

  def response_created(request_lines, request_count, hello_count)
    path = @request_formatter.path(request_lines)
    return hello_world_response(hello_count) if path == "/hello"
    return date_time_response if path == "/datetime"
    return word_search_response(request_lines) if path.start_with?\
    ("/word_search?")
    return shutdown_response(request_count) if path == "/shutdown"
    return root_response(request_lines)
  end

  def root_response(request_lines)
    @request_formatter.request_full_output(request_lines)
  end

  def hello_world_response(hello_count)
    "Hello World! (#{hello_count})"
  end

  def date_time_response
    Time.now.strftime('%H:%M%p on %A, %B %d, %Y')
  end

  def word_search_response(request_lines)
    WordSearch.new.word_search_response(request_lines)
  end

  def shutdown_response(request_count)
    "Total requests: #{request_count}"
  end

end
