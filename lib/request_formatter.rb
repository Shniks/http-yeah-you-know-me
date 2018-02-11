class RequestFormatter

  def request_full_output(request_lines)
    "<pre>\nVerb: #{verb(request_lines)}\nPath: #{path(request_lines)\
    }\nProtocol: #{protocol(request_lines)}\nHost: #{host(request_lines)\
    }\nPort: #{port(request_lines)}\nOrigin: #{origin(request_lines)\
    }\n#{accept(request_lines)}\n</pre>"
  end

  def verb(request_lines)
    request_lines[0].split(" ")[0]
  end

  def path(request_lines)
    request_lines[0].split(" ")[1]
  end

  def protocol(request_lines)
    request_lines[0].split(" ")[2]
  end

  def host(request_lines)
    request_lines.select { |line| line.start_with?("Host:") }[0].split(":")\
    [1].strip
  end

  def origin(request_lines)
    host(request_lines)
  end

  def port(request_lines)
    request_lines.select { |line| line.start_with?("Host:") }[0].split(":")[2]
  end

  def accept(request_lines)
    request_lines.select { |line| line.start_with?("Accept:") }[0]
  end

  def parameter_words(request_lines)
    path = request_lines[0].split(" ")[1]
    [] if path.split("?").length == 1
    parameters = path.split("?")[1].split("&")
    parameter_split_multiple_words(parameters)
  end

  def parameter_split_multiple_words(parameters)
    parameters.map do |parameter|
      parameter.split("=")[1]
    end
  end

end
