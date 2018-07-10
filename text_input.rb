require 'gosu'

class TextInput < Gosu::Window
  def initialize
    @font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 32)
    self.text_input = Gosu::TextInput.new
    self.text_input.text = "Enter your username"
  end

  def draw
    @font.draw(self.text_input.text, 20, 40, 0)
  end
end 

# window = TextInput.new.show


