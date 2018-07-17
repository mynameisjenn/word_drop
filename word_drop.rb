require 'gosu'
require 'unirest'
require_relative 'word'
require_relative 'word_list'
require_relative 'score'
require_relative 'prompt'
require_relative 'game_actionable'
require_relative 'level'

class WordDrop < Gosu::Window
  HEIGHT = 700
  WIDTH = 500

  include GameActionable
  
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Word Drop"
    @background_image = Gosu::Image.new('visuals/start_screen_2.png')
    @word_bubble = Gosu::Image.new('visuals/talk_bubble.gif')
    @hamster = Gosu::Image.new("visuals/hamster.png")
    @title = Gosu::Font.new(self, "visuals/ARCADE.TTF", 72)
    @input = Gosu::Font.new(self, "visuals/ARCADE.TTF", 40)
    self.text_input = Gosu::TextInput.new


    if File.exist?("username.json")
      user_json_file = File.read("username.json")
      user_hash = JSON.parse(user_json_file)
      previous_username = user_hash["username"]
      self.text_input.text = previous_username
    else
      self.text_input.text = ""
    end
    
    @start_message = Gosu::Font.new(self, "visuals/ARCADE.TTF", 45)
    @start_music = Gosu::Song.new('sounds/sequence-8-bit-music-loop.wav')
    @start_music.play(looping = true)

    @hidden_list = WordList.new
    get_words_from_grammarslayer(1)

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
    @title.draw("Word Drop", @title.text_width("Word Drop") / 2.2, 100, 2)
    @start_message.draw("Press Enter to Start", @title.text_width("Press Enter to Start") / 7, 250, 2)
    @input.draw("Username:", 75, 575, 2)
    @word_bubble.draw(250, 375, 2)
    @hamster.draw(200, 450, 2)
    
    ## need to center this
    @input.draw(self.text_input.text, 225, 575, 0)
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
    if id == Gosu::KbReturn
      input = self.text_input.text  
      
      user_hash = {"username" => input}
      
      File.open("username.json", "w") do |f|
        f.write(user_hash.to_json)
      end

      response = Unirest.get("http://localhost:3000/api/users/username/#{input}")
      @user = response.body
      initialize_game
    end
  end

  def button_down_game(id)
    if (id == Gosu::MsLeft) 
      @word_list.each do |word|
        if word.left < mouse_x && word.right > mouse_x && word.top < mouse_y && word.bottom > mouse_y
          if word.check_type(@prompt.word_type) 
            @word_list.delete word
            @score.correct
            @count += 1
            @prompt = @prompts.sample
            @correct_sound.play
          else
            @score.incorrect
            
          end
        end
      end
    elsif (id == Gosu::KbRightAlt)
      @word_list.each do |word|
          word.move_right if word.speed != 0 && word.right <= 450
      end
    elsif (id == Gosu::KbLeftAlt)
      @word_list.each do |word|
          word.move_left if word.speed != 0 && word.current_x >= 50 
      end
    else (id == Gosu::KbSpace)
      @prompt = @prompts.sample
      @score.incorrect
    end
  end



  def initialize_end(fate)
    case fate
    when :too_many_words
      @lose_message = "GAME OVER!"
      @lose_message_2 = "Your score is #{@score.value.to_s}!"
      response = Unirest.post(
                            "http://localhost:3000/api/game_plays", 
                             parameters: {
                                      user_id: @user["id"],
                                      score: @score.value,
                                      level: @level.value
                                    }
                        )
    when :levels_cleared
      @win_message = "You cleared all the levels! Congrats!"
      @win_message_2 = "Your score is #{@score.value.to_s}!"
      response = Unirest.post(
                            "http://localhost:3000/api/game_plays", 
                             parameters: {
                                      user_id: @user["id"],
                                      score: @score.value,
                                      level: @level.value
                                    }
                        )
    end
    @bottom_message = "Press P to play again,"
    @bottom_message_2 = "or Q to quit."
    @message_font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 50)
    @game_over_font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 72)
    @scene = :end
  end

  def draw_end
    @score.draw_end
    @background_image.draw(0,0,0)

    @message_font.draw(@win_message, 100, 200, 1, 1, 1)
    @message_font.draw(@win_message_2, 50, 300, 1, 1, 1)

    @game_over_font.draw(@lose_message, 100, 150, 1, 1, 1)
    @message_font.draw(@lose_message_2, 100, 350, 1, 1, 1)

    @message_font.draw(@bottom_message, 50, 450, 1, 1, 1)
    @message_font.draw(@bottom_message_2, 150, 500, 1, 1, 1)
  end

  def update_end
   
  end

  def button_down_end(id)
    if id == Gosu::KbP
      initialize_game
    elsif id == Gosu::KbQ
      close
    end      
  end

  def get_words_from_grammarslayer(current_level = 1)
    response = Unirest.get(
                            "http://localhost:3000/api/words",
                            parameters: { level: current_level }
                            )
    word_hashs = response.body["words"].shuffle!

    word_hashs.each {|word_hash| @hidden_list << Word.new(window: self, word_data: word_hash) }

    @prompts = response.body["word_types"].map do |word_type|
      Prompt.new(window: self, word_type: word_type)
    end
    @prompt = @prompts.sample
  end

  def level_up
    @level.increase_level
    @level_up_sound.play
  end


  def check_for_collision
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
    end


  def lock
    @word_list.each do |word|
      word.speed = 0
    end
  end

end



window = WordDrop.new
window.show