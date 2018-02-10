require 'socket'
require 'faraday'
require './lib/server'
require_relative 'test_helper'

class ServerTest < Minitest::Test

  def test_if_it_exists
    server = Server.new(9292)

    assert_instance_of Server, server
  end

end
