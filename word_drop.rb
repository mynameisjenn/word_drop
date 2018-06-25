require 'gosu'
require_relative 'square'
require_relative 'score'
require_relative 'prompt'
require_relative 'timer'


WIDTH = 500
HEIGHT = 700


class WordDrop < Gosu::Window

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Word Drop"
    @square = Square.new(self, @column, 0, :green, @word)
    @squares = [ ]
    @mag_glass = Gosu::Image.new('visuals/hand.png')
    @score = Score.new(self, @x, @y, 2)
    @prompt = Prompt.new(self, @x, @y, 2)
    @timer = Timer.new(self, @x, @y, 2)
    @background = Gosu::Image.new('visuals/back.png')
  
  end

  def update
    @square.fall
    @timer.start
    if @square.stack_6
      @squares << @square

      @square = Square.new(self, @column, 0, :purple, @word)
      @prompt = Prompt.new(self, @x, @y, 2)
    end
    
    @timer.stop
    @squares << @square
  end


  def draw
    @square.draw
    @mag_glass.draw(mouse_x - 25, mouse_y - 25, 3)
    @score.draw
    @prompt.draw
    @background.draw(0, 0, 0)
    @timer.draw
  end

  def button_down(id)
    if (id == Gosu::MsLeft) && Gosu.distance(mouse_x - 25, mouse_y - 25, @square.current_x, @square.current_y) < 50 
      @square.clear
      @square = Square.new(self, @column, 0, :purple, @word)
      @prompt = Prompt.new(self, @x, @y, 2)
      @score.correct
    elsif
      (id == Gosu::MsLeft) && Gosu.distance(mouse_x - 25, mouse_y - 25, @square.current_x, @square.current_y) < 50 
      @score.incorrect
    end
  end
  
end

window = WordDrop.new
window.show