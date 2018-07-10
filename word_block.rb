require 'gosu'


GRID_IN_PIXELS = 50
DEFAULT_SPEED = 2

class WordBlock < Gosu::Window 

  attr_reader :current_y, :current_x, :word, :color, :speed
  attr_writer :speed

  def initialize(options_hash)
    colors = [
              0xaa624CD1, 
              0xaa00aa00, 
              0xaa0000aa
            ]

    @color = Gosu::Color.argb(colors.sample)

    @@window ||= options_hash[:window]
    @@font ||= Gosu::Font.new(@@window, "visuals/ARCADE.TTF", 45)
    @word = options_hash[:word_data]["content"]
    
    @column = rand(0..6)
    @row = 0
    
    @current_y = @row * GRID_IN_PIXELS
    @current_x = @column * GRID_IN_PIXELS

    @text_width = @@font.text_width(@word)
    @width = find_width
    @border_width = 1
    
    @speed = DEFAULT_SPEED
  end

  def draw
    if @word != 0
      x1 = 11 + @current_x
      y1 = 11 + @current_y
      x2 = x1 + @width
      y2 = y1
      x3 = x2
      y3 = y2 + GRID_IN_PIXELS - (@border_width * 2)
      x4 = x1 
      y4 = y3
      c = @color
      @@window.draw_quad(x1, y1, c, x2, y2, c, x3, y3, c, x4, y4, c, 2)  
      @x_center = x1 + (@width - (@border_width * 2)) / 2
      @x_text = @x_center - @text_width / 2 
      @y_text = y1 + 6
      @@font.draw(@word, @x_text, @y_text, 3)   
    end
  end

  def fall
    @current_y += speed
  end

  def find_width
    cols = 1
    while @text_width > GRID_IN_PIXELS * cols
      cols += 1
    end
    cols * GRID_IN_PIXELS - 1
  end
 

  def collision_with_floor
    if @current_y > 550
      @speed = 0
    end
  end

  def top
    @current_y
  end

  def bottom
    @current_y + GRID_IN_PIXELS
  end

  def left
    @current_x
  end

  def right 
    @current_x + @width
  end

  def right_of?(other_square)
    left > other_square.right && right > other_square.right
  end

  def left_of?(other_square)
    right < other_square.left && left < other_square.left
  end


  
  def collision_with_block(other_square)
    if self != other_square && bottom == other_square.top 
      unless left_of?(other_square) || right_of?(other_square)
        @speed = 0
      end
    end
  end
   

end
