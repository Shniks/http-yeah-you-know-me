require './lib/server'
require './lib/request_formatter'

class Sequence

  def start
    server = Server.new(9292)
    get_path
  end

  def get_path
    RequestFormatter.new
  end





end
