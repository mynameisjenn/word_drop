require 'unirest'

# class User 
#   attr_reader :id, :username

#   def initialize
    response = Unirest.get("http://localhost:3000/api/users")
    user_info = response.body
    id = [ ]
    user_info.each do |user| 
      id << user["id"] 
    end

#     @id = user_info["id"]
#     @username = user_info["username"]
#   end

#   def find_id(input)
#     @id
#   end


# end



p id
  