require './lib/server'
require './lib/request_formatter'
require './lib/responder'
require './lib/game'

class Sequence

  def start
    server = Server.new(9292)
    request_formatter = RequestFormatter.new
    request_count = 0
    hello_count = 0

    puts "\nReady for a request...\n(Press 'ctrl + c' at any time to exit)\n "

    loop do
      server.accept_request
      request_lines = server.request_from_client
      path = request_formatter.path(request_lines)
      responder = Responder.new

      response = responder.response_created(request_lines, request_count, hello_count)
      server.response_from_server(response)
      
      request_count += 1
      hello_count += 1 if path == "/hello"

      if path == "/start_game" && request_formatter.verb(request_lines) == "POST"
        game = Game.new(server)
        game.run
      end

      break if path == "/shutdown"
    end

    server.close_the_server
  end

end
