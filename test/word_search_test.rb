require './lib/word_search'
require_relative 'test_helper'

class WordSearchTest < Minitest::Test

  def setup
    @wordsearch = WordSearch.new
  end

  def test_if_it_exists
    assert_instance_of WordSearch, @wordsearch
  end

  def test_if_it_initializes_request_formatter_class
    assert_instance_of RequestFormatter, @wordsearch.request_formatter
  end

  def test_if_it_can_send_response_for_word_search_path
    request_lines = ["GET /word_search?word=milk&word=honey&word=cake HTTP/1.1"]
    path = "/word_search?"

    assert_instance_of String, @wordsearch.word_search(path, request_lines)
  end

  def test_its_response_to_incorrect_word_search_path
    request_lines = ["GET /word_search?word=milk&word=honey&word=cake HTTP/1.1"]
    path = "/hello"

    assert_nil nil, @wordsearch.word_search(path, request_lines)
  end

  def test_if_it_can_check_for_a_known_word
    expected = "VICARLY is a known word."

    assert_equal expected, @wordsearch.word_check("vicarly")
  end

  def test_if_it_can_check_for_an_unknown_word
    expected = "MIKESMUSICCHOICE is not a known word."

    assert_equal expected, @wordsearch.word_check("mikesmusicchoice")
  end

  def test_if_it_can_search_multiple_known_words
    request_lines = ["GET /word_search?word=milk&word=honey HTTP/1.1"]
    expected = "MILK is a known word.\nHONEY is a known word."

    assert_equal expected, @wordsearch.word_search_response(request_lines)
  end

  def test_if_it_can_search_known_and_unknown_words
    request_lines = ["GET /word_search?word=milk&word=craycray HTTP/1.1"]
    expected = "MILK is a known word.\nCRAYCRAY is not a known word."

    assert_equal expected, @wordsearch.word_search_response(request_lines)
  end

  def test_if_it_can_search_multiple_unknown_words
    request_lines = ["GET /word_search?word=grrf&word=craycray HTTP/1.1"]
    expected = "GRRF is not a known word.\nCRAYCRAY is not a known word."

    assert_equal expected, @wordsearch.word_search_response(request_lines)
  end

end
