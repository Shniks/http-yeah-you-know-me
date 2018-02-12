require './lib/responder'
require_relative 'test_helper'

class ResponderTest < Minitest::Test

  def setup
    @responder = Responder.new
    @request_lines = ["GET /hello HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
  end

  def test_if_it_exists
    assert_instance_of Responder, @responder
  end

  def test_root_path_response
    request_lines = ["GET / HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    expected_1 = "<pre>\nVerb: GET\nPath: /\nProtocol:\ HTTP/1.1\n"
    expected_2 = "<pre>\nVerb: GET\nPath: /hello\nProtocol:\ HTTP/1.1\n"
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert result.include?(expected_1)
    refute result.include?(expected_2)
  end

  def test_root_response
    expected_1 = "<pre>\nVerb: GET\nPath: /hello\nProtocol:\ HTTP/1.1\n"
    expected_2 = "Port: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>"
    result = @responder.root_response(@request_lines)

    assert result.include?(expected_1)
    assert result.include?(expected_2)
  end

  def test_miscellaneous_path_response
    request_lines = ["GET /testing HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    expected = "<pre>\nVerb: GET\nPath: /testing\nProtocol:\ HTTP/1.1\n"
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert result.include?(expected)
  end

  def test_hello_world_path_response
    request_lines = ["GET /hello HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert result.include?("Hello World! (12)")
  end

  def test_hello_world_response
    hello_count = 12
    result = @responder.hello_world_response(@request_lines, hello_count)

    assert result.include?("Hello World! (12)")
    refute result.include?("Hello World! (11)")
  end

  def test_date_time_path_response
    request_lines = ["GET /datetime HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert_instance_of String, @responder.date_time_response(request_lines)
  end

  def test_date_time_response
    request_lines = ["GET /datetime HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]

    assert_instance_of String, @responder.date_time_response(request_lines)
  end

  def test_word_search_response_can_send_response_for_word_search_path
    request_lines = ["GET /word_search?word=milk&word=honey&word=cake\
     HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive",\
     "Cache-Control: no-cache","User-Agent: Mozilla/5.0 (Macintosh; Intel Mac\
     OS X 10_13_2)\ AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert_instance_of String, result
  end

  def test_word_search_response_can_check_for_a_known_word
    request_lines = ["GET /word_search?word=vicarly HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    expected = "VICARLY is a known word."
    result = @responder.word_search_response(request_lines)

    assert result.include?(expected)
  end

  def test_word_search_response_can_check_for_an_unknown_word
    request_lines = ["GET /word_search?word=mikesmusicchoice HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    expected = "MIKESMUSICCHOICE is not a known word."
    result = @responder.word_search_response(request_lines)

    assert result.include?(expected)
  end

  def test_word_search_path_response_multiple_known_words
    request_lines = ["GET /word_search?word=milk&word=honey HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    expected = "MILK is a known word.\nHONEY is a known word."
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert result.include?(expected)
  end

  def test_word_search_response_can_search_multiple_known_words
    request_lines = ["GET /word_search?word=milk&word=honey HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    expected = "MILK is a known word.\nHONEY is a known word."
    result = @responder.word_search_response(request_lines)

    assert result.include?(expected)
  end

  def test_word_search_path_response_known_and_unknown_words
    request_lines = ["GET /word_search?word=milk&word=craycray HTTP/1.1",\
     "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control:\
     no-cache","User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    expected = "MILK is a known word.\nCRAYCRAY is not a known word."
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert result.include?(expected)
  end

  def test_word_search_response_can_search_known_and_unknown_words
    request_lines = ["GET /word_search?word=milk&word=craycray HTTP/1.1",\
     "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control:\
     no-cache","User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    expected = "MILK is a known word.\nCRAYCRAY is not a known word."
    result = @responder.word_search_response(request_lines)

    assert result.include?(expected)
  end

  def test_word_search_path_response_multiple_unknown_words
    request_lines = ["GET /word_search?word=grrf&word=craycray HTTP/1.1",\
     "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control:\
     no-cache","User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    expected = "GRRF is not a known word.\nCRAYCRAY is not a known word."
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert result.include?(expected)
  end

  def test_word_search_response_can_search_multiple_unknown_words
    request_lines = ["GET /word_search?word=grrf&word=craycray HTTP/1.1",\
     "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control:\
     no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    expected = "GRRF is not a known word.\nCRAYCRAY is not a known word."
    result = @responder.word_search_response(request_lines)

    assert result.include?(expected)
  end

  def test_shutdown_path_response
    request_lines = ["GET /shutdown HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 3
    hello_count = 12
    expected = "Total requests: 3"
    result = @responder.response_created(request_lines, request_count,\
    hello_count)

    assert result.include?(expected)
  end

  def test_shutdown_response_can_send_response_for_shutdown_path
    request_lines = ["GET /shutdown HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
    request_count = 12
    expected = "Total requests: 12"
    result = @responder.shutdown_response(request_lines, request_count)

    assert result.include?(expected)
  end

end
