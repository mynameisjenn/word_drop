require 'gosu'
require 'unirest'
require_relative 'word'
require_relative 'word_list'
require_relative 'score'
require_relative 'prompt'
require_relative 'game_actionable'
require_relative 'level'
require_relative 'keys_actionable'

class WordDrop < Gosu::Window
  HEIGHT = 700
  WIDTH = 500

  include GameActionable
  include KeysActionable
  
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Word Drop"
    @background_image = Gosu::Image.new('visuals/start_screen.png')
    @word_bubble_start = Gosu::Image.new('visuals/talk_bubble.gif')

    @word_bubble_end = Gosu::Image.new('visuals/game_over.png')
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
    
    @word_bubble_start.draw(250, 375, 2)
    @hamster.draw(200, 450, 2)
    
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



  def initialize_end(fate)
    case fate
    when :too_many_words
      @lose_message = "GAME OVER"
      @lose_message_2 = "Score: #{@score.value.to_s}"
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
    @small_message_font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 45)
    @medium_message_font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 60)
    @large_message_font = Gosu::Font.new(self, "visuals/ARCADE.TTF", 90)
    @scene = :end
  end

  def draw_end
    @score.draw_end
    @background_image.draw(0,0,0)

    @large_message_font.draw(@lose_message, 75, 150, 1, 1, 1)
    @medium_message_font.draw(@lose_message_2, 150, 450, 1, 1, 1)

    @word_bubble_end.draw(250, 275, 2)
    @hamster.draw(200, 350, 2)

    @small_message_font.draw(@bottom_message, 50, 600, 1, 1, 1)
    @small_message_font.draw(@bottom_message_2, 150, 650, 1, 1, 1)
  end

  def update_end
    
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

end



window = WordDrop.new
window.show