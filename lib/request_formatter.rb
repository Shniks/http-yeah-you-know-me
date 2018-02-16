class RequestFormatter

  attr_reader :guess,
              :content_length

  def request_full_output(request_lines)
    ["<pre>", "Verb: #{verb(request_lines)}", "Path: #{path(request_lines)}",
    "Protocol: #{protocol(request_lines)}", "Host: #{host(request_lines)}",
    "Port: #{port(request_lines)}", "Origin: #{origin(request_lines)}",
    "#{accept(request_lines)}", "</pre>"].join("\n")
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
    request_lines.select { |line| line.start_with?("Host:") }\
    [0].split(":")[1].strip
  end

  def origin(request_lines)
    host(request_lines)
  end

  def port(request_lines)
    request_lines.select { |line| line.start_with?("Host:") }\
    [0].split(":")[2]
  end

  def accept(request_lines)
    request_lines.select { |line| line.start_with?("Accept:") }[0]
  end

  def parameter_words(request_lines)
    return [] if path(request_lines).split("?").length == 1
    parameters = path(request_lines).split("?")[1].split("&")
    parameter_split_multiple_words(parameters)
  end

  def parameter_split_multiple_words(parameters)
    parameters.map do |parameter|
      parameter.split("=")[1]
    end
  end

  def request_content_length(request_lines)
    @content_length = request_lines.select { |line| line.start_with?("Content-Length:") }[0].split(":")[1].to_i
  end

  def location(request_lines)
    return "Location: http://#{host(request_lines)}:#{port(request_lines)\
    }#{path(request_lines)}\r\n"
  end

  def user_guess(body)
    @guess = body.split("\r\n")[-2].to_i
  end

end
