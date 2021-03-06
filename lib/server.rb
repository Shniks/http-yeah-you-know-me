require 'socket'
require './lib/request_formatter'
require './lib/responder'

class Server

  attr_reader :tcp_server

  def initialize(port)
    @tcp_server = TCPServer.new(port)
    @formatter = RequestFormatter.new
    @responder = Responder.new
  end

  def sequence
    accept_request
    request = read_the_request
    response = @responder.route(request, @client)
    response_from_server(response)
    terminate_sequence(request)
  end

  def accept_request
    puts "Ready for a request...\n(Press 'ctrl + c' at any time to exit)\n "
    @client = @tcp_server.accept
  end

  def read_the_request
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def response_from_server(response)
    @output = "<html><head></head><body>#{response[0]}</body></html>"
    @client.puts header(response, @output)
    @client.puts @output
  end

  def terminate_sequence(request)
    if @formatter.path(request) == '/shutdown'\
       || @formatter.path(request) == '/force_error'
      close_the_server
    else
      sequence
    end
  end

  def close_the_server
    @client.close
    @tcp_server.close
    puts ["Wrote this response:", @output].join("\n")
  end

  def header(response, output, location = nil)
    location = "Location: http://127.0.0.1:9292/game"\
     if response[1] == "302 Moved Permanently"
    ["http/1.1 #{response[1]}",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

end
