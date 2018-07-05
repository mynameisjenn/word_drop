require 'unirest'

# class Text

#   attr_reader :content, :word_types

  # def initialize(text_options)

    response = Unirest.get("http://localhost:3000/api/words")
    @word_hash = response.body["words"].shuffle!
    # @prompt_objects = response.body["word_types"].map do |word_type|
    #   Prompt.new(self, word_type)
    # end
  # end


  #  def 
      @word_hash 
#     end
# end

  p @word_hash[0]
  p @prompt_objects

# class Word
#   attr_accessor :content, :word_types
#   def initialize(options_hash)
#     @content = options_hash["content"]
#     @word_types = options_hash["word_types"]
#   end
# end

# class WordList < Array
#   def find_by_type(word_type)
#     self.select {|word| word.word_types.include?(word_type) }.sample
#   end
# end

# word_hashs = [
#               { "content" => "run", "word_types" => ["verb", "noun"]},
#               { "content" => "base", "word_types" => ["verb", "noun"]},
#               { "content" => "house", "word_types" => ["noun"]},
#               { "content" => "bat", "word_types" => ["noun"]},
#               { "content" => "swim", "word_types" => ["verb"]},
#               { "content" => "bang", "word_types" => ["verb"]}
#               ]

# word_list = WordList.new

# word_hashs.each do |word_hash|
#   word_list << Word.new(word_hash)
# end

# p word_list.find_by_type("noun")