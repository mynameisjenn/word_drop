require 'gosu'

class Level
  attr_accessor :value

  def initialize(window)
    @font = Gosu::Font.new(window, "visuals/ARCADE.TTF", 50)
    @value = 1
    @x = 450
    @y = 650
    @window = window
  end

  def draw_game
    @font.draw("Level", 300, @y, 2)
    @font.draw("#{@value}", @x, @y, 2)
  end

  def draw_end
    @font.draw("Level", 300, @y, 2)
    @font.draw("#{@value}", @x, @y, 2)
  end

  def increase_level
    @value += 1
  end

end