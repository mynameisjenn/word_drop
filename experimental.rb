require 'unirest'

response = Unirest.get("http://localhost:3000/api/words")
@hidden_list = response.body["words"]
@word = @hidden_list.pop

p @word


p @word["part_of_speech"]["verb"]