require 'gosu'

class Score
  attr_accessor :value

  def initialize(window, text, x, y)
    @font = Gosu::Font.new(window, "visuals/ARCADE.TTF", 50)
    @value = 0
    @x = 200
    @y = 650
    @window = window
  end

  def draw_game
    @font.draw("Score", 50, @y, 2)
    @font.draw("#{@value}", @x, @y, 2)
  end

  def draw_end
    @font.draw("Score", 250, @y, 2)
    @font.draw("#{@value}", @x, @y, 2)
  end
  
  def correct
      @value += 2
  end

  def incorrect
     @value -= 1
  end

  def count
    @count += 1
  end


end
