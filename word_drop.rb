require 'gosu'
require 'unirest'
require_relative 'word_block'
require_relative 'score'
require_relative 'prompt'



WIDTH = 500
HEIGHT = 700


class WordDrop < Gosu::Window

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Word Drop"
    @blocks = [ ]

    response = Unirest.get("http://localhost:3000/api/words")
    @hidden_list = response.body["words"].shuffle!

    @prompt_objects = response.body["word_types"].map do |word_type|
      Prompt.new(self, word_type)
    end

    @mag_glass = Gosu::Image.new('visuals/hand.png')
    @score = Score.new(self, @x, @y, 2)
    @background = Gosu::Image.new('visuals/back.png')
  end

  def update

    new_block = true

    @blocks.each do |block|
      block.fall
    end

    @blocks.each do |block|
      collided = false

      @blocks.each do |compare_block|
        if block.collision_with_block(compare_block)
          collided = true
        end
      end

      if collided
        block.speed = 0
      else
        block.speed = 2
      end

      block.collision_with_floor

    end

    @blocks.each do |block|
      new_block = false if block.speed != 0
    end


    if new_block
      @blocks << WordBlock.new(
                              window: self, 
                              word_data: @hidden_list.pop
                              )
      @prompt_object = @prompt_objects.sample
    end

  end

  def draw
    @blocks.each do |block|
      block.draw
    end
    @mag_glass.draw(mouse_x, mouse_y, 3)
    @score.draw
    @prompt_object.draw
    @background.draw(0, 0, 0)
  end

  def button_down(id)
    if (id == Gosu::MsLeft) 
      @blocks.each do |block|
        # if @prompt_object.word_type == 
          if block.left < mouse_x && block.right > mouse_x && block.top < mouse_y && block.bottom > mouse_y 
            @blocks.delete block
          end
        # end
      end
    end
    @score.correct
  end

end

window = WordDrop.new
window.show