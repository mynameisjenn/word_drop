require 'gosu'

class Prompt < Gosu::Window
    def initialize(window, text, x, y)
      @font = Gosu::Font.new(window, "visuals/ARCADE.TTF", 50)
      @prompts = ["noun", "adjective", "verb"].sample
      @y = 50
      @x = 500
  
    end

  def draw
    @part_of_speech = @prompts
    @x_start = 140
    @x_text = @x_start - @font.text_width("#{@part_of_speech}") / 2
    @font.draw("Click the #{@part_of_speech}!!", @x_text, @y, 2) 
  end

end

# @x_text = @x_center - @@font.text_width("#{@word}") / 2 
# @y_text = y1 + 6
