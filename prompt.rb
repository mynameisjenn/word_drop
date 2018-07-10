require 'gosu'

class Prompt

  attr_reader :word_type
  
  def initialize(options)
    @font = Gosu::Font.new(options[:window], "visuals/ARCADE.TTF", 50)
    @y = 50
    @word_type = options[:word_type]
  end

  def draw
    @x_start = 140
    @x_text = @x_start - @font.text_width("#{@word_type}") / 2
    @font.draw("Click the #{@word_type}!!", @x_text, @y, 2) 
  end


end

