require_relative 'word'
require_relative 'word_list'

response = [
{
"id" => 1,
"content" => "cat",
"part_of_speech" => {
"noun" => true,
"verb" => false,
"adjective" => false,
"pronoun" => false,
"preposition" => false,
"article" => false,
"conjunction" => false,
"adverb" => false
}
},
{
"id" => 2,
"content" => "smelly",
"part_of_speech" => {
"noun" => false,
"verb" => false,
"adjective" => true,
"pronoun" => false,
"preposition" => false,
"article" => false,
"conjunction" => false,
"adverb" => false
}
},
{
"id" => 3,
"content" => "sleeps",
"part_of_speech" => {
"noun" => false,
"verb" => true,
"adjective" => false,
"pronoun" => false,
"preposition" => false,
"article" => false,
"conjunction" => false,
"adverb" => false
}
},
{
"id" => 4,
"content" => "dog",
"part_of_speech" => {
"noun" => true,
"verb" => false,
"adjective" => false,
"pronoun" => false,
"preposition" => false,
"article" => false,
"conjunction" => false,
"adverb" => false
}
},
{
"id" => 5,
"content" => "squishy",
"part_of_speech" => {
"noun" => false,
"verb" => false,
"adjective" => true,
"pronoun" => false,
"preposition" => false,
"article" => false,
"conjunction" => false,
"adverb" => false
}
}]



@hidden_list = WordList.new

response.each do |word_hash|
  @hidden_list << Word.new(word_hash)
end


p @hidden_list.search_by_type("adjective")



























# # class Word

# #   attr_reader :content, :word_types

# #   def initialize(text_options)

#     # response = Unirest.get("http://localhost:3000/api/words")
#     # @hidden_list = response.body["words"].shuffle!

#    response = Unirest.get("http://localhost:3000/api/words")
#     @hidden_list = response.body["words"].shuffle!
#     # @content = [ ]
#     @word_list = [ ]
# #   end
# # end

# # p @hidden_list

# @text = @hidden_list.each do |word|
#     @word_list << word if word["part_of_speech"]["noun"]
# end

# # p @word_list 

# @word_list.each do | list_item |
#  p list_item
#  puts "gg"
# end




# # h = { "a" => 100, "b" => 200 }
# # h.each {|key, value| puts "#{key} is #{value}" }
# # produces:
# # a is 100
# # b is 200


# # h.each_key{|key| puts "key is #{key} "
# # produces:
# # key is a
# # key is b

# # h.each_value{|value| puts "value is #{value} "
# # produces:
# # value is 100
# # value is 200


# # class WordList < Array
#   # def find_by_type(word_type)
#     # @word_list.select {|element| element.include?("noun") }.sample
# #   end
# # # end

# # # # word_hashs = [
# # # #               { "content" => "run", "word_types" => ["verb", "noun"]},
# # # #               { "content" => "base", "word_types" => ["verb", "noun"]},
# # # #               { "content" => "house", "word_types" => ["noun"]},
# # # #               { "content" => "bat", "word_types" => ["noun"]},
# # # #               { "content" => "swim", "word_types" => ["verb"]},
# # # #               { "content" => "bang", "word_types" => ["verb"]}
# # # #               ]

# # # p @hidden_list

# # # # word_list = WordList.new

# # # # @content.each do |word_hash|


# # # #   # word_list << Word.new(word_hash)
# # # # end

# # p @word_list.find_by_type("noun")

