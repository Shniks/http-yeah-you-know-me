require './lib/request_formatter'
require_relative 'test_helper'

class RequestFormatterTest < Minitest::Test

  def setup
    @request_formatter = RequestFormatter.new
  end


 def test_if_it_exists
   assert_instance_of RequestFormatter, @request_formatter
 end

 def test_request_full_output
   request_lines = ["GET /hello HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
   expected = "<pre>""\n""Verb: GET""\n""Path: /hello""\n""Protocol: HTTP/1.1""\n""Host: 127.0.0.1""\n""Port: 9292""\n""Origin: 127.0.0.1""\n""Accept: */*""\n""</pre>"

   assert_equal expected, @request_formatter.request_full_output(request_lines)
 end

 def test_request_path
   request_lines = ["GET /hello HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
   expected = "/hello"

   assert_equal expected, @request_formatter.request_path(request_lines)
   refute_equal "/shutdown", @request_formatter.request_path(request_lines)
 end

 def test_request_verb
   request_lines = ["GET /hello HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
   expected = "GET"

   assert_equal expected, @request_formatter.request_verb(request_lines)
   refute_equal "POST", @request_formatter.request_verb(request_lines)
 end

 def test_parameters_one_parameter
   request_lines = ["GET /word_search?word=milk HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]

   assert_equal ["milk"], @request_formatter.parameter_words(request_lines)
   refute_equal ["milk", "honeys"], @request_formatter.parameter_words(request_lines)
 end

 def test_parameters_three_parameters
   request_lines = ["GET /word_search?word=milk&word=honey&word=cake HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]

   assert_equal ["milk", "honey", "cake"], @request_formatter.parameter_words(request_lines)
   refute_equal ["milk", "honeys", "cake"], @request_formatter.parameter_words(request_lines)
 end

end
