require 'unirest'




response = Unirest.get("http://localhost:3000/api/words")

words = response.body["words"]


p words

 # def level_up
 #    level_up = true
 #      @word_list.each do |word|
 #      if word.speed != 0
 #        word.speed += 1
 #      else
 #        word.speed = 0
 #      end
 #    end 
 #  end