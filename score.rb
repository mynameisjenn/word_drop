require 'gosu'
require 'unirest'

class Score
  attr_reader :value

  def initialize(window, text, x, y)
    @font = Gosu::Font.new(window, "visuals/ARCADE.TTF", 50)
    @value = 0
    @x = 300
    @y = 650
    @window = window
  end

  def draw_game
    @font.draw("Score", 150 , @y, 2 )
    @font.draw("#{@value}", @x, @y, 2)
  end

  def draw_end
    @font.draw("Score", 150 , @y, 2 )
    @font.draw("#{@value}", @x, @y, 2)
  end
  
  def correct
      @value += 2
  end

  def incorrect
     @value -= 1
  end

  # def store_score
  #   response = Unirest.post(
  #                           "http://localhost:3000/api/game_plays", 
  #                            parameters: {
  #                                     user_id: 1,
  #                                     score: @score,
  #                                     level: 1
  #                                   }
  #                       )
  # end

end
