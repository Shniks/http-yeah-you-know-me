require './lib/server'
require './lib/request_formatter'
require './lib/responder'
require './lib/game'

class Sequence

  def start
    server = Server.new(9292) #ok
    request_formatter = RequestFormatter.new #okay
    request_count = 0
    hello_count = 0

    puts "\nReady for a request...\n(Press 'ctrl + c' at any time to exit)\n " #okay

    loop do
      server.accept_request #okay
      request_lines = server.read_the_request #okay
      # binding.pry
      path = request_formatter.path(request_lines)
      verb = request_formatter.verb(request_lines)
      responder = Responder.new #okay

      response = responder.response_created(request_lines, request_count, hello_count) #okay
      server.response_from_server(response) #okay

      request_count += 1 #okY
      hello_count += 1 if path == "/hello" #okay

      if path == "/start_game" && verb == "POST"
        game = Game.new(server)
        game.run
      end

      break if path == "/shutdown" #okay
    end

    server.close_the_server #okay
  end

end
