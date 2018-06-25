require 'gosu'
require_relative 'square'
require_relative 'prompt'
require_relative 'score'


class WordTest < Gosu::Window

  def initialize
    super(500, 700)
    self.caption = "Word Drop"
    @square = Square.new(self, @column, 0, :green, @word)
    @mag_glass = Gosu::Image.new('visuals/hand.png')
    @score = Score.new(self, @x, @y, 2)
    @prompt = Prompt.new(self, @x, @y, 2)
    @background = Gosu::Image.new('visuals/back.png')
  end

  def draw
    @square.draw
    @mag_glass.draw(mouse_x - 25, mouse_y - 25, 3)
    @score.draw
    @prompt.draw
  end

  def update
    @square.fall
    if @square.current_y > 625
      @square.speed = 0
    end

  end

  def button_down(id)
    if (id == Gosu::MsLeft) && Gosu.distance(mouse_x - 25, mouse_y - 25, @square.current_x, @square.current_y) < 50 
      @square.clear
      @score.correct
    else 
      (id == Gosu::MsLeft) && Gosu.distance(mouse_x - 25, mouse_y - 25, @square.current_x, @square.current_y) < 50
      @score.incorrect
    end
  end
  
end

window = WordTest.new
window.show