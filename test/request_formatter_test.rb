require './lib/request_formatter'
require_relative 'test_helper'

class RequestFormatterTest < Minitest::Test

  def setup
    @request_formatter = RequestFormatter.new
    @request_lines = ["GET /hello HTTP/1.1", "Host: 127.0.0.1:9292",
      "Connection: keep-alive", "Cache-Control: no-cache",
      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)
      AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36",
      "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c", "Accept: */*",
      "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
  end

 def test_if_it_exists
   assert_instance_of RequestFormatter, @request_formatter
 end

 def test_request_full_output
   expected = "<pre>""\n""Verb: GET""\n""Path: /hello""\n""Protocol: HTTP/1.1"\
   "\n""Host: 127.0.0.1""\n""Port: 9292""\n""Origin: 127.0.0.1""\n"\
   "Accept: */*""\n""</pre>"
   result = @request_formatter.request_full_output(@request_lines)

   assert_equal expected, result
 end

 def test_request_verb
   assert_equal "GET", @request_formatter.verb(@request_lines)
   refute_equal "POST", @request_formatter.verb(@request_lines)
 end

 def test_request_path
   assert_equal "/hello", @request_formatter.path(@request_lines)
   refute_equal "/shutdown", @request_formatter.path(@request_lines)
 end

 def test_request_protocol
   assert_equal "HTTP/1.1", @request_formatter.protocol(@request_lines)
   refute_equal "HTTP/", @request_formatter.protocol(@request_lines)
 end

 def test_request_host
   assert_equal "127.0.0.1", @request_formatter.host(@request_lines)
   refute_equal "127.0.0.1:9292", @request_formatter.host(@request_lines)
 end

 def test_request_origin
   assert_equal "127.0.0.1", @request_formatter.origin(@request_lines)
   refute_equal "127.0.0.1:9292", @request_formatter.origin(@request_lines)
 end

 def test_request_port
   assert_equal "9292", @request_formatter.port(@request_lines)
   refute_equal "127.0.0.1:9292", @request_formatter.port(@request_lines)
 end

 def test_request_accept
   assert_equal "Accept: */*", @request_formatter.accept(@request_lines)
   refute_equal "*/*", @request_formatter.accept(@request_lines)
 end

 def test_parameter_with_one_parameter
   request_lines = ["GET /word_search?word=milk HTTP/1.1", "Host:\
    127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
    "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
    AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
    Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
    "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
    "Accept-Language: en-US,en;q=0.9"]

   result = @request_formatter.parameter_words(request_lines)

   assert_equal ["milk"], result
   refute_equal ["milk", "honeys"],result
 end

 def test_parameter_with_three_parameters
   request_lines = ["GET /word_search?word=milk&word=honey&word=cake HTTP/1.1"\
    , "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control\
    : no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
    AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"\
    , "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c", "Accept: */*",\
    "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]

   result = @request_formatter.parameter_words(request_lines)

   assert_equal ["milk", "honey", "cake"], result
   refute_equal ["milk", "honeys", "cake"], result
 end

 def test_parameter_split_multiple_words_method_can_split_multiple_words
   parameters = ["word=milk", "word=honey", "word=cake"]
   result = @request_formatter.parameter_split_multiple_words(parameters)

   assert_equal ["milk", "honey", "cake"], result
   refute_equal ["milk", "honeys", "cake"], result
 end

end
