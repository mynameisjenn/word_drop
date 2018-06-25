require 'gosu'
require 'unirest'


GRID_IN_PIXELS = 50

class Square < Gosu::Window 

  attr_reader :current_y, :current_x, :column, :row, :word, :color, :speed
  attr_writer :speed

  def initialize(window, column, row, color, text)
    @@colors ||= { purple: Gosu::Color.argb(0xaa624CD1), 
                   green: Gosu::Color.argb(0xaa00ff00),
                   blue: Gosu::Color.argb(0xaa0000ff) 
                 }
    @@font ||= Gosu::Font.new(window, "visuals/ARCADE.TTF", 45)
    @@window ||= window

    response = Unirest.get("http://localhost:3000/api/words")
    @hidden_list = response.body["words"].shuffle!
    @full_word = @hidden_list.pop
    @word = @full_word["content"]


    @row = row
    @column = rand(0..6)

    @current_y = row * GRID_IN_PIXELS
    @current_x = @column * GRID_IN_PIXELS
    
    @color = color

    @width = find_width
    @border_width = 0.5
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

  def stack_6
    if @current_y > 550
      @speed = 0
    end
  end

  # def stack_5
  #   if @current_y > 500
  #     @speed = 0
  #   end
  # end

  # def stack_4
  #   if @current_y > 450 
  #     @speed = 0
  #   end
  # end

  # def stack_3
  #   if @current_y > 400
  #     @speed = 0
  #   end
  # end

  # def stack_2
  #   if @current_y > 350
  #     @speed = 0
  #   end
  # end

  # def stack_1
  #   if @current_y > 300
  #     @speed = 0
  #   end
  # end



end
