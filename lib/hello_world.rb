require './lib/sequence'

class HelloWorld

  attr_reader :hello_count

  def initialize
    @hello_count = 0
  end

  def hello_world(path)
    @hello_count +=1 if path == "./hello"
  end

  def hello_world_response
    "Hello World! (#{@hello_count})"
  end

end
