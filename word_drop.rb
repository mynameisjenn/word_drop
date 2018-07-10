require 'gosu'
require 'unirest'
require_relative 'word'
require_relative 'word_list'
require_relative 'score'
require_relative 'prompt'


class WordDrop < Gosu::Window
  WIDTH = 500
  HEIGHT = 700
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Word Drop"
    @background_image = Gosu::Image.new('visuals/back.png')
    @title = Gosu::Font.new(self, "visuals/ARCADE.TTF", 60)
    @input = Gosu::Font.new(self, "visuals/ARCADE.TTF", 40)
    self.text_input = Gosu::TextInput.new
    self.text_input.text = ""
    @start_message = Gosu::Font.new(self, "visuals/ARCADE.TTF", 45)
    @start_music = Gosu::Song.new('sounds/sequence-8-bit-music-loop.wav')
    @start_music.play(looping = true)
    @scene = :start
  end

  def draw
    case @scene
    when :start
      draw_start
    when :game
      draw_game
    when :end
      draw_end
    end
  end


  def draw_start
    @background_image.draw(0,0,0)
    @title.draw("Word Drop", 125, 200, 2)
    @start_message.draw("Press Spacebar to Start", 45, 300, 2)
    @input.draw("Please Enter Username:", 75, 500, 45)
    @input.draw(self.text_input.text, 115, 550, 0)
  end

  def draw_game
    @word_list.each do |word|
      word.draw
    end
    @mag_glass.draw(mouse_x, mouse_y, 3)
    @score.draw_game
    @prompt.draw
    @background.draw(0, 0, 0)
  end

  def update
    case @scene
    when :game
      update_game
    when :end
      update_end
    end
  end

  def button_down(id)
    case @scene
    when :start
      button_down_start(id)
    when :game
      button_down_game(id)
    when :end
      button_down_end(id)
    end
  end

  def button_down_start(id)
    if id == Gosu::KbSpace
      puts self.text_input
      initialize_game
    end
  end

  def initialize_game
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

    @game_music = Gosu::Song.new('sounds/sequence-8-bit-music-loop.wav')
    @game_music.play(looping = true)
    @impact = Gosu::Sample.new('sounds/swooshy-fight-straight-hit.wav')
    @correct_sound = Gosu::Sample.new('sounds/swooshy-fight-straight-hit.wav')
    @scene = :game
  end

  def update_game
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

    initialize_end(:too_many) if @word_list.count > 2
    initialize_end(:less_than_five) if @word_list.count < 0


    if new_word 
      @word_list << @hidden_list.pop
    end

    initialize_end(:too_many) if @word_list.count > 2
    initialize_end(:less_than_five) if @word_list.count == 0
  end

  def button_down_game(id)
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
    @score.correct
  end

  def initialize_end(fate)
    case fate
    when :too_many
      @lose_message = "You lost!"
      @lose_message_2 = "Your score is #{@score.value.to_s}!"
    when :less_than_five
      @win_message = "You won!"
      @win_message_2 = "Your score is #{@score.value.to_s}!"
    end
    @bottom_message = "Press P to play again,"
    @bottom_message_2 = "or Q to quit."
    @message_font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 50)
    @scene = :end
  end

  def draw_end
    @score.draw_end
    @background_image.draw(0,0,0)
    @message_font.draw(@win_message, 150, 200, 1, 1, 1)
    @message_font.draw(@win_message_2, 50, 300, 1, 1, 1)
    @message_font.draw(@lose_message, 150, 200, 1, 1, 1)
    @message_font.draw(@lose_message_2, 50, 300, 1, 1, 1)
    @message_font.draw(@bottom_message, 50, 400, 1, 1, 1)
    @message_font.draw(@bottom_message_2, 50, 450, 1, 1, 1)
  end

  def update_end
    # @score.store_score
  end

  def button_down_end(id)
    if id == Gosu::KbP
      initialize_game
    elsif id == Gosu::KbQ
      close
    end      
  end
end

window = WordDrop.new
window.show