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
  end

  def response_from_server(response)
    @output = "<html><head></head><body>#{response}</body></html>"
    @headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
    @client.puts @headers
    @client.puts @output
  end

  def close_the_server
    puts ["Wrote this response:", @headers, @output].join("\n")
    @client.close
    @tcp_server.close
  end

end
