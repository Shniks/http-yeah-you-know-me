require './lib/sequence'
require './lib/request_formatter'

class Root

  attr_reader :request_formatter

  def initialize
    @request_formatter = RequestFormatter.new
  end

  def root(path, request_lines)
    return root_response(request_lines) if path == "/"
  end

  def root_response(request_lines)
    request_formatter.request_full_output(request_lines)
  end

end
