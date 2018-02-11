require './lib/server'
require './lib/request_formatter'

class Sequence

  def start
    server = Server.new(9292)
    request_formatter
  end

  def request_formatter
    RequestFormatter.new
  end





end
