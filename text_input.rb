# require 'gosu'

# class TextInput < Gosu::Window
#   def initialize()
#     @font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 32)
#     text_input = Gosu::TextInput.new(self)
#     text_input.text = "Enter your username"
#   end

#   def draw
#     @font.draw(self.text_input.text, 20, 40, 0)
#   end

# end 



# window = TextInput.new.show


# require 'gosu'
# require 'tempfile'

# class KeyboardExample < Gosu::Window
#   def initialize
#     super 640, 480
#     self.caption = "Keyboard Example"
#     @font = Gosu::Font.new(32, name: "Nimbus Mono L")
#     self.text_input = Gosu::TextInput.new
#     self.text_input.text = "Type something!"
#   end

#   def draw

#     @font.draw(self.text_input.text, 20, 40, 0)
    
#   end


# end 

# window = KeyboardExample.new.show