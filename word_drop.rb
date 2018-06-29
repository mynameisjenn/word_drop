require 'gosu'
require_relative 'word_block'
require_relative 'score'
require_relative 'prompt'


WIDTH = 500
HEIGHT = 700


class WordDrop < Gosu::Window

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Word Drop"
    @squares = [ ]
    @prompts = [ ]

    @mag_glass = Gosu::Image.new('visuals/hand.png')
    @score = Score.new(self, @x, @y, 2)
    @prompt = Prompt.new(self, 'noun')
    @background = Gosu::Image.new('visuals/back.png')

    response = Unirest.get("http://localhost:3000/api/words")
    @hidden_list = response.body["words"].shuffle!

  end

  def update
    new_square = true

    @squares.each do |square|
      square.check_collision_with_floor
      square.fall
     
      new_square = false if square.speed != 0
      @squares.each do |compare_square|
        square.check_square_collision(compare_square)
      end
    end

    if new_square
      @square = WordBlock.new(self, @column, 0, :purple, @hidden_list.pop)
      @squares << @square

      @prompt = Prompt.new(self, 'noun')
      @prompts << @prompt
    end

  end


  def draw
    @squares.each do |square|
      square.draw
    end
    @mag_glass.draw(mouse_x - 25, mouse_y, 3)
    @score.draw
    @prompt.draw
    @background.draw(0, 0, 0)
   
  end

  def button_down(id)
    if (id == Gosu::MsLeft) 
      @squares.delete_if do |square| 
        square.left < mouse_x && square.right > mouse_x && square.top < mouse_y && square.bottom > mouse_y 
      end
    @score.correct
    end
  end
  
end

window = WordDrop.new
window.show