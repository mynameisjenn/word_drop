require 'gosu'
require 'unirest'


GRID_IN_PIXELS = 50

class WordBlock < Gosu::Window 

  attr_reader :current_y, :current_x, :column, :word, :color, :speed
  attr_writer :speed

  def initialize(window, column, row, color, word_data)
    @@colors ||= { purple: Gosu::Color.argb(0xaa624CD1), 
                   green: Gosu::Color.argb(0xaa00ff00),
                   blue: Gosu::Color.argb(0xaa0000ff) 
                 }
    @@font ||= Gosu::Font.new(window, "visuals/ARCADE.TTF", 45)
    @@window ||= window
    @word = word_data["content"]
    # @noun = word_data["noun"]
    # @adjective = word_data["adjective"]
    # @verb = word_data["verb"]
    
    @column = rand(0..6)
    
    @row = row
    @current_y = @row * GRID_IN_PIXELS
    @current_x = @column * GRID_IN_PIXELS
    
    @color = color

    @width = find_width
    @border_width = 1
    @speed = 2
    @score = 0
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
      c = @@colors[@color]
      @@window.draw_quad(x1, y1, c, x2, y2, c, x3, y3, c, x4, y4, c, 2)  
      @x_center = x1 + (@width - (@border_width * 2)) / 2
      @x_text = @x_center - @@font.text_width("#{@word}") / 2 
      @y_text = y1 + 6
      @@font.draw("#{@word}", @x_text, @y_text, 1)   
    end
  end

  def fall
    @current_y += speed
  end

  def find_width
    cols = 1
    while @@font.text_width("#{@word}") > GRID_IN_PIXELS * cols
      cols += 1
    end
    cols * GRID_IN_PIXELS - 1
  end

  def clear
    @word = 0
  end 

  def check_collision_with_floor
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

  def is_right_of?(other_square)
    left > other_square.right && right > other_square.right
  end

  def is_left_of?(other_square)
    right < other_square.left && left < other_square.left
  end

  def check_square_collision(other_square)
    if self != other_square && bottom > other_square.top
      unless self.is_left_of?(other_square) || self.is_right_of?(other_square)
        @speed = 0
      end
    end
  end


  # def overlap
  #   if mouse_x > left && mouse_x < right && mouse_y > bottom && mouse_y < top 
  #   end
  # end
    

end
