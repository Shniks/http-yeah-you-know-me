require './lib/root'
require_relative 'test_helper'

class RootTest < Minitest::Test

  def setup
    @root = Root.new
    @request_lines = ["GET /hello HTTP/1.1", "Host:\
     127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache",\
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)\
     AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84\
     Safari/537.36", "Postman-Token: b2e47831-a988-11c7-5312-757131842c6c",\
     "Accept: */*", "Accept-Encoding: gzip, deflate, br",\
     "Accept-Language: en-US,en;q=0.9"]
  end

  def test_if_it_exists
    assert_instance_of Root, @root
  end

  def test_if_it_can_send_response_for_root_path
    path = "/"

    assert_instance_of String, @root.root(path, @request_lines)
  end

  def test_its_response_to_incorrect_root_path
    path = "/hello"

    assert_nil nil, @root.root(path, @request_lines)
  end

  def test_root_response
    expected_1 = "<pre>\nVerb: GET\nPath: /hello\nProtocol:\ HTTP/1.1\n"
    expected_2 = "Port: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>"
    result = @root.root_response(@request_lines)

    assert result.include?(expected_1)
    assert result.include?(expected_2)
  end

  def test_root_response_from_root_path
    path = "/"
    expected_1 = "<pre>\nVerb: GET\nPath: /hello\nProtocol:\ HTTP/1.1\n"
    expected_2 = "Port: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>"
    result = @root.root(path, @request_lines)

    assert result.include?(expected_1)
    assert result.include?(expected_2)
  end

end
