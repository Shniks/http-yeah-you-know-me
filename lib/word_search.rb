require './lib/request_formatter'

class WordSearch

  attr_reader :dictionary,
              :request_formatter

  def initialize
    @dictionary = File.read("/usr/share/dict/words").split("\n")
    @request_formatter = RequestFormatter.new
  end

  def word_search(path, request_lines)
    word_search_response(request_lines) if path.start_with?("/word_search?")
  end

  def word_search_response(request_lines)
    parsed_words = request_formatter.parameter_words(request_lines)
    parsed_words.map do |word|
      word_check(word)
    end.join("\n")
  end

  def word_check(word)
    return "#{word.upcase} is a known word."\
    if dictionary.include?(word.downcase)
    "#{word.upcase} is not a known word."
  end

end
