require 'socket'
require 'pry'

class Server

  def initialize(port)
    @tcp_server = TCPServer.new(port)
  end

  def accept_request
    @client = @tcp_server.accept
  end

  def request_from_client
    puts "Ready for a request...\n(Press 'ctrl + c' at any time to exit)\n "
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
    binding.pry
  end

  def request_from_game_client
    puts "Enter your guess...\n(Press 'ctrl + c' at any time to exit)\n "
    request_lines_game = []
    line_number = false
    while line = @client.gets and !line.chomp.empty?
      request_lines_game << line.chomp
    end
    request_lines_game
  end

  def response_from_server(response)
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
  end

  def response_from_game_server
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 302 found",
              "Location: http://127.0.0.1:9292/game",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
  end

  def close_the_server
    @client.close
    @tcp_server.close
  end

end
