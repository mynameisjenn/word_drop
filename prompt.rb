require 'gosu'

class Prompt

  attr_reader :word_type
  
  def initialize(window, word_type)
    @font = Gosu::Font.new(window, "visuals/ARCADE.TTF", 50)
    @y = 50
    @part_of_speech = word_type
  end

  def draw
    @x_start = 140
    @x_text = @x_start - @font.text_width("#{@part_of_speech}") / 2
    @font.draw("Click the #{@part_of_speech}!!", @x_text, @y, 2) 
  end
end

