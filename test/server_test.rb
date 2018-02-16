require 'socket'
require 'faraday'
require './lib/server'
require_relative 'test_helper'

class ServerTest < Minitest::Test

  def test_server_responds_to_root
    response = Faraday.get 'http://127.0.0.1:9292/'
    expected = "<html><head></head><body><pre>\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre></body></html>"

    assert_equal expected, response.body
  end

  def test_server_responds_to_hello
    response = Faraday.get 'http://127.0.0.1:9292/hello'
    result = "<html><head></head><body><pre>\nVerb: GET\nPath: /hello\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>\nHello World!"

    assert response.body.include?(result)
  end

  def test_server_responds_to_datetime
    response = Faraday.get 'http://127.0.0.1:9292/datetime'
    result = "<html><head></head><body><pre>\nVerb: GET\nPath: /datetime\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>\n#{Time.now.strftime('%H:%M%p on %A, %B %d, %Y')}"

    assert response.body.include?(result)
  end

  def test_server_responds_to_word_search
    response = Faraday.get 'http://127.0.0.1:9292/word_search'
    expected = "<html><head></head><body><pre>\nVerb: GET\nPath: /word_search\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre></body></html>"

    assert_equal expected, response.body
  end

  def test_server_responds_to_word_search_test_word
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=milk'
    expected = "<html><head></head><body><pre>\nVerb: GET\nPath: /word_search?word=milk\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>\nMILK is a known word.</body></html>"

    assert_equal expected, response.body
  end

  def test_server_responds_to_word_search_incorrect_test_word
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=grrrfff'
    expected = "<html><head></head><body><pre>\nVerb: GET\nPath: /word_search?word=grrrfff\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>\nGRRRFFF is not a known word.</body></html>"

    assert_equal expected, response.body
  end

end
