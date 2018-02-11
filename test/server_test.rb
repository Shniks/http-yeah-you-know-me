require 'socket'
require 'faraday'
require './lib/server'
require_relative 'test_helper'

class ServerTest < Minitest::Test

  def setup
    @server = Server.new(9292)
  end

  def teardown
    skip
    @server.close_the_server
  end

  def test_if_it_exists
    skip
    assert_instance_of Server, @server
  end

end
