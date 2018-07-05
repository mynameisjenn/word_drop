require 'unirest'


response = Unirest.get("http://localhost:3000/api/words")
@hidden_list = response.body["words"].shuffle!
    
  available_prompts = @hidden_list.map do |word_hash|
    pos_true = word_hash["part_of_speech"].select { |k, v| v == true }
    pos_true.map {|k, v| k }
      end
    @prompts = available_prompts.flatten.uniq
    
p @prompts


