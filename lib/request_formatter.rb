require 'pry'

class RequestFormatter

  def request_full_output(request_lines)
    verb = request_lines[0].split(" ")[0]
    path = request_lines[0].split(" ")[1]
    protocol = request_lines[0].split(" ")[2]
    host = request_lines.select { |line| line.start_with?("Host:") }[0].split(":")[1].strip
    port = request_lines.select { |line| line.start_with?("Host:") }[0].split(":")[2]
    origin = host
    accept = request_lines.select { |line| line.start_with?("Accept:") }[0]
    "<pre>\nVerb: #{verb}\nPath: #{path}\nProtocol: #{protocol}\nHost: #{host}\nPort: #{port}\nOrigin: #{origin}\n#{accept}\n</pre>"
  end

  def request_path(request_lines)
    request_lines[0].split(" ")[1]
  end

  def request_verb(request_lines)
    request_lines[0].split(" ")[0]
  end

  def parameter_words(request_lines)
    path = request_lines[0].split(" ")[1]
    if path.split("?").length == 1
      []
    else
      parameters = path.split("?")[1].split("&")
      parameters.map do |parameter|
        parameter.split("=")[1]
      end
    end
  end

end
