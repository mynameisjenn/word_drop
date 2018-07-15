require 'gosu'

class Level
  attr_accessor :level_increment

  def initialize(window, text, x, y)
    @font = Gosu::Font.new(window, "visuals/ARCADE.TTF", 50)
    @level_increment = 1
    @x = 450
    @y = 650
    @window = window
  end

  def draw_game
    @font.draw("Level", 300, @y, 2)
    @font.draw("#{@level_increment}", @x, @y, 2)
  end

  def draw_end
    @font.draw("Level", 300, @y, 2)
    @font.draw("#{@level_increment}", @x, @y, 2)
  end

  def change_level
    @value += 1
  end

end