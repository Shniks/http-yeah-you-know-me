require './lib/hello_world'
require_relative 'test_helper'

class HelloWorldTest < Minitest::Test

  def setup
    @helloworld = HelloWorld.new
  end

  def test_if_it_exists
    assert_instance_of HelloWorld, @helloworld
  end

  def test_if_count_is_initially_zero
    assert_equal 0, @helloworld.hello_count
  end

  def test_if_count_can_increase
    @helloworld.hello_world("/hello")

    assert_equal 1, @helloworld.hello_count
    refute_equal 0, @helloworld.hello_count
  end

  def test_if_count_can_increase_multiple_times
    12.times do
      @helloworld.hello_world("/hello")
    end

    assert_equal 12, @helloworld.hello_count
  end

  def test_if_count_can_increase_multiple_times
    12.times do
      @helloworld.hello_world("/hello")
    end

    assert_equal 12, @helloworld.hello_count
  end

  def test_if_it_can_send_a_response
    12.times do
      @helloworld.hello_world("/hello")
    end

    assert_equal "Hello World! (12)", @helloworld.hello_world_response
    refute_equal "Hello World! (11)", @helloworld.hello_world_response
  end

end
