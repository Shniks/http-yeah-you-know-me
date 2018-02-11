require './lib/sequence'

class Shutdown

  def shutdown(path, request_count)
    shutdown_response(request_count) if path == "/shutdown"
  end

  def shutdown_response(request_count)
    "Total requests: #{request_count}"
  end

end
