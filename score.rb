require 'gosu'

class Score < Gosu::Window

  def initialize(window, text, x, y)
    @font = Gosu::Font.new(window, "visuals/ARCADE.TTF", 50)
    @score = 0
    @x = 300
    @y = 650
    @window = window
  end

  def draw
    @font.draw("Score", 150 , @y, 2 )
    @font.draw(@score.to_s, @x, @y, 2)
  end
  
  def correct
      @score += 2
  end

  def incorrect
     @score -= 1
  end

end
