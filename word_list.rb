require_relative 'word'

class WordList < Array

  def search_by_type(word_type)
    self.select {|word| word.check_type(word_type) }
  end

end