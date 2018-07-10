require 'gosu'

WIDTH = 500
HEIGHT = 700


class StartScreen < Gosu::Window
  SPEED = 1
  attr_reader = :y

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Word Drop"
    @background_image = Gosu::Image.new('visuals/back.png')
    @font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 50)
    @input = Gosu::Font.new(self, "visuals/ARCADE.TTF", 40)
    self.text_input = Gosu::TextInput.new
    self.text_input.text = "username"
    @y = 250
    @x = 125
    @speed = 1
  end

  def draw
    @background_image.draw(0,0,0)
    @font.draw("Word Drop",@x, @y, 45)
    @font.draw("Please Enter",@x, @y + 100, 45)
    @font.draw(self.text_input.text, 20, 40, 0)
  end

end

window = StartScreen.new
window.show