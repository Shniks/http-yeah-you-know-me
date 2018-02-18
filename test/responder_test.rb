require './lib/responder'
require_relative 'test_helper'

class ResponderTest < Minitest::Test

  def setup
    @responder = Responder.new
    @request_lines = ["GET /hello HTTP/1.1", "Host: 127.0.0.1:9292"]
  end

  def test_if_it_exists
    assert_instance_of Responder, @responder
  end

  def test_root_path_response
    request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292"]
    expected = "<pre>\nVerb: GET\nPath: /\nProtocol:\ HTTP/1.1\n"
    result = @responder.route(request_lines)

    assert result[0].include?(expected)
  end

  def test_root_response
    expected = "<pre>\nVerb: GET\nPath: /hello\nProtocol:\ HTTP/1.1\n"
    result = @responder.root_response(@request_lines)

    assert result[0].include?(expected)
  end

  def test_miscellaneous_path_response
    request_lines = ["GET /testing HTTP/1.1", "Host: 127.0.0.1:9292"]
    expected = "404 Not Found"
    result = @responder.route(request_lines)

    assert result[1].include?(expected)
  end

  def test_hello_world_path_response
    request_count = 3
    hello_count = 12
    result = @responder.route_get(@request_lines, request_count,\
    hello_count)

    assert result[0].include?("Hello World! (12)")
  end

  def test_route_post
    request_lines = ["POST /something HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.route(request_lines)

    assert_equal "404 Not Found", result[1]
  end

  def test_force_error
    request_lines = ["GET /force_error HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.route(request_lines)

    assert_equal "500 Internal Server Error", result[1]
  end

  def test_hello_world_response
    hello_count = 12
    result = @responder.hello_world_response(@request_lines, hello_count)

    assert result[0].include?("Hello World! (12)")
    refute result[0].include?("Hello World! (11)")
  end

  def test_date_time_path_response
    request_lines = ["GET /datetime HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.date_time_response(request_lines)[0].split("\n").last
    expected = Time.now.strftime('%H:%M%p on %A, %B %d, %Y')

    assert_equal expected, result
  end

  def test_date_time_response
    request_lines = ["GET /datetime HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.route(request_lines)[0].split("\n").last
    expected = Time.now.strftime('%H:%M%p on %A, %B %d, %Y')

    assert_equal expected, result
  end

  def test_word_search_response_can_send_response_for_word_search_path
    request_lines = ["GET /word_search?word=milk&word=honey&word=cake\
     HTTP/1.1", "Host: 127.0.0.1:9292"]
    request_count = 3
    hello_count = 12
    result = @responder.route_get(request_lines, request_count,\
    hello_count)

    assert_instance_of String, result[0]
  end

  def test_word_search_response_can_check_for_a_known_word
    request_lines = ["GET /word_search?word=vicarly HTTP/1.1", "Host:\
     127.0.0.1:9292"]
    expected = "VICARLY is a known word."
    result = @responder.word_search_response(request_lines)

    assert result[0].include?(expected)
  end

  def test_word_search_response_can_check_for_an_unknown_word
    request_lines = ["GET /word_search?word=mikesmusicchoice HTTP/1.1", "Host:\
     127.0.0.1:9292"]
    expected = "MIKESMUSICCHOICE is not a known word."
    result = @responder.word_search_response(request_lines)

    assert result[0].include?(expected)
  end

  def test_word_search_path_response_multiple_known_words
    request_lines = ["GET /word_search?word=milk&word=honey HTTP/1.1", "Host:\
     127.0.0.1:9292"]
    request_count = 3
    hello_count = 12
    expected = "MILK is a known word.\nHONEY is a known word."
    result = @responder.route_get(request_lines, request_count,\
    hello_count)

    assert result[0].include?(expected)
  end

  def test_word_search_response_can_search_multiple_known_words
    request_lines = ["GET /word_search?word=milk&word=honey HTTP/1.1", "Host:\
     127.0.0.1:9292"]
    expected = "MILK is a known word.\nHONEY is a known word."
    result = @responder.word_search_response(request_lines)

    assert result[0].include?(expected)
  end

  def test_word_search_path_response_known_and_unknown_words
    request_lines = ["GET /word_search?word=milk&word=craycray HTTP/1.1",\
     "Host: 127.0.0.1:9292"]
    request_count = 3
    hello_count = 12
    expected = "MILK is a known word.\nCRAYCRAY is not a known word."
    result = @responder.route(request_lines)

    assert result[0].include?(expected)
  end

  def test_word_search_response_can_search_known_and_unknown_words
    request_lines = ["GET /word_search?word=milk&word=craycray HTTP/1.1",\
     "Host: 127.0.0.1:9292"]
    expected = "MILK is a known word.\nCRAYCRAY is not a known word."
    result = @responder.word_search_response(request_lines)

    assert result[0].include?(expected)
  end

  def test_word_search_path_response_multiple_unknown_words
    request_lines = ["GET /word_search?word=grrf&word=craycray HTTP/1.1",\
     "Host: 127.0.0.1:9292"]
    request_count = 3
    hello_count = 12
    expected = "GRRF is not a known word.\nCRAYCRAY is not a known word."
    result = @responder.route(request_lines)

    assert result[0].include?(expected)
  end

  def test_word_search_response_can_search_multiple_unknown_words
    request_lines = ["GET /word_search?word=grrf&word=craycray HTTP/1.1",\
     "Host: 127.0.0.1:9292"]
    expected = "GRRF is not a known word.\nCRAYCRAY is not a known word."
    result = @responder.word_search_response(request_lines)

    assert result[0].include?(expected)
  end

  def test_game_response
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.route(request_lines)[0].split("\n").last
    expected = "Good luck!"

    assert_equal expected, result
  end

  def test_another_game_response
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.route(request_lines)[0].split("\n").last
    request_lines = ["POST /start_game HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.route(request_lines)[0].split("\n").last
    expected = "Game in progress!"

    assert_equal expected, result
  end

  def test_game_GET_response
    request_lines = ["GET /game HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.route(request_lines)[0].split("\n").last
    expected = "No game in progress!"

    assert_equal expected, result
  end

  def test_game_POST_response
    request_lines = ["POST /game HTTP/1.1", "Host: 127.0.0.1:9292"]
    result = @responder.route(request_lines)[0].split("\n").last
    expected = "No game in progress!"

    assert_equal expected, result
  end

  def test_shutdown_path_response
    request_lines = ["GET /shutdown HTTP/1.1", "Host:\
     127.0.0.1:9292"]
    request_count = 3
    hello_count = 12
    expected = "Total requests: 3"
    result = @responder.route_get(request_lines, request_count,\
    hello_count)

    assert result[0].include?(expected)
  end

  def test_shutdown_response_can_send_response_for_shutdown_path
    request_lines = ["GET /shutdown HTTP/1.1", "Host:\
     127.0.0.1:9292"]
    request_count = 12
    expected = "Total requests: 12"
    result = @responder.shutdown_response(request_lines, request_count)

    assert result[0].include?(expected)
  end

end
