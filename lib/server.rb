require 'socket'
require './lib/request_formatter'
require './lib/responder'
require 'pry'

class Server

  def initialize(port)
    @tcp_server = TCPServer.new(port)
    @formatter = RequestFormatter.new
    @responder = Responder.new
  end

  def sequence
    accept_request
    @request = read_the_request
    response = @responder.response_created(@request)
    response_from_server(response)
    terminate_sequence(@request)
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
    @output = "<html><head></head><body>#{response}</body></html>"
    @client.puts header(@output)
    @client.puts @output
  end

  def terminate_sequence(request)
    unless @formatter.path(request) == '/shutdown' || @formatter.path(request) == '/force_error'
      sequence
    end
    close_the_server
  end

  def close_the_server
    puts ["Wrote this response:", @headers, @output].join("\n")
    @client.close
    @tcp_server.close
  end

  def header(output)
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

end
