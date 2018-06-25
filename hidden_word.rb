require 'unirest'

module HiddenWord 
  
    response = Unirest.get("http://localhost:3000/api/words")
    @hidden_list = response.body["words"]
    @full_word = @hidden_list.pop
    @word = @full_word["content"]
 

  def single_word
    @word
  end

  def full_word
    @full_word
  end

end

