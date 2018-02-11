require './lib/shutdown'
require_relative 'test_helper'

class ShutdownTest < Minitest::Test

  def setup
    @shutdown = Shutdown.new
  end

  def test_if_it_exists
    assert_instance_of Shutdown, @shutdown
  end

  def test_if_it_can_send_response_for_shutdown_path
    path = "/shutdown"
    request_count = 12
    expected = "Total requests: #{request_count}"

    assert_equal expected, @shutdown.shutdown(path, request_count)
  end

  def test_its_response_to_incorrect_shutdown_path
    path = "/hello"
    request_count = 12

    assert_nil nil, @shutdown.shutdown(path, request_count)
  end

end
