require 'gosu'

class Timer
  def initialize(window, text, x, y)
    @font = Gosu::Font.new(window, "visuals/ARCADE.TTF", 40)
    @x = 0
    @y = 0 
    @time_left = 0
    @playing = true
  end

  def draw
    @font.draw(" * Countdown * ", 110, 100, 2)
    @font.draw(@time_left.to_i, 220, 140, 2)
    # unless @playing
    #   @font.draw('LEVEL UP', 150, 300, 3)
    # end
  end

  def start
    @time_left = 30 - Gosu.milliseconds / 1000
  end

  def stop
    if @time_left < 0
      @playing = false
      @time_left = 0
    # ""
    # if you got +10 or more move to the next level
    end
  end

end

      
    