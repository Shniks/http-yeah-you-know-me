require 'socket'
require 'faraday'
require './lib/server'
require_relative 'test_helper'

class ServerTest < Minitest::Test

  def test_if_it_has_a_server
    server = Server.new(9191)
    request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292"]

    assert_instance_of Server, server
    server.tcp_server.close
  end

  def test_if_it_has_headers
    server = Server.new(9191)
    output = "Testing this piece"

    assert server.header(output).include?("text/html; charset=iso-8859-1")
    server.tcp_server.close
  end

  def test_server_responds_to_root
    response = Faraday.get 'http://127.0.0.1:9292/'
    expected_1 = "<body><pre>\nVerb: GET\nPath: /\n"
    expected_2 = "</pre></body></html>"

    assert response.body.include?(expected_1)
    assert response.body.include?(expected_2)
  end

  def test_server_responds_to_hello
    response = Faraday.get 'http://127.0.0.1:9292/hello'
    expected_1 = "<body><pre>\nVerb: GET\nPath: /hello\n"
    expected_2 = "</pre>\nHello World!"

    assert response.body.include?(expected_1)
    assert response.body.include?(expected_2)
  end

  def test_server_responds_to_datetime
    response = Faraday.get 'http://127.0.0.1:9292/datetime'
    expected_1 = "<body><pre>\nVerb: GET\nPath: /datetime\n"
    expected_2 = "</pre>\n#{Time.now.strftime('%H:%M%p on %A, %B %d, %Y')}"

    assert response.body.include?(expected_1)
    assert response.body.include?(expected_2)
  end

  def test_server_responds_to_word_search_test_word
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=milk'
    expected_1 = "<body><pre>\nVerb: GET\nPath: /word_search?word=milk\n"
    expected_2 = "</pre>\nMILK is a known word.</body></html>"

    assert response.body.include?(expected_1)
    assert response.body.include?(expected_2)
  end

  def test_server_responds_to_word_search_incorrect_test_word
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=grrrfff'
    expected_1 = "<body><pre>\nVerb: GET\nPath: /word_search?word=grrrfff\n"
    expected_2 = "</pre>\nGRRRFFF is not a known word.</body></html>"

    assert response.body.include?(expected_1)
    assert response.body.include?(expected_2)
  end

end
