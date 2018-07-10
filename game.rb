require 'gosu'
require 'unirest'
require_relative 'word'
require_relative 'word_list'
require_relative 'score'
require_relative 'prompt'


WIDTH = 500
HEIGHT = 700


class Game < Gosu::Window

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Word Drop"

    @word_list = WordList.new
    response = Unirest.get("http://localhost:3000/api/words")
    word_hashs = response.body["words"].shuffle!

    @hidden_list = WordList.new
    word_hashs.each {|word_hash| @hidden_list << Word.new(window: self, word_data: word_hash) }


    @prompts = response.body["word_types"].map do |word_type|
      Prompt.new(window: self, word_type: word_type)
    end

    @mag_glass = Gosu::Image.new('visuals/hand.png')
    @score = Score.new(self, @x, @y, 2)
    @background = Gosu::Image.new('visuals/back.png')
    @prompt = @prompts.sample

    @start_music = Gosu::Song.new('sounds/sequence-8-bit-music-loop.wav')
    @start_music.play(looping = true)
    @impact = Gosu::Sample.new('sounds/swooshy-fight-straight-hit.wav')
    @correct_sound = Gosu::Sample.new('sounds/swooshy-fight-straight-hit.wav')
  end

  def update

    new_word = true

    @word_list.each do |word|
      word.fall
    end

    @word_list.each do |word|
      collided = false

      @word_list.each do |compare_word|
        if word.collision_with_block(compare_word)
          collided = true
        end
      end

      if collided
        word.speed = 0
      else
        word.speed = 2
      end

      word.collision_with_floor

    end

    @word_list.each do |word|
      new_word = false if word.speed != 0
    end


    if new_word
      @word_list << @hidden_list.pop
    end

  end

  def draw
    @word_list.each do |word|
      word.draw
    end
    @mag_glass.draw(mouse_x, mouse_y, 3)
    @score.draw
    @prompt.draw
    @background.draw(0, 0, 0)
  end

  def button_down(id)
    if (id == Gosu::MsLeft) 
      @word_list.each do |word|
        if word.left < mouse_x && word.right > mouse_x && word.top < mouse_y && word.bottom > mouse_y
          if word.check_type(@prompt.word_type) 
            @word_list.delete word
            @score.correct
            @prompt = @prompts.sample
            @correct_sound.play
          else
            @score.incorrect
            @prompt = @prompts.sample

          end
        end
      end
    end
  end

end

window = Game.new
window.show