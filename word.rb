require 'gosu'


GRID_IN_PIXELS = 50

class Word
  attr_accessor  :speed, :height, :current_y, :current_x

  attr_reader :id, :content, :noun, :verb, :adjective, :pronoun, :preposition, :article, :conjunction, :adverb, :color

  def initialize(options)
                  
      @id = options[:word_data]["id"]
      @content = options[:word_data]["content"]
      @noun = options[:word_data]["part_of_speech"]["noun"]
      @verb = options[:word_data]["part_of_speech"]["verb"]
      @adjective = options[:word_data]["part_of_speech"]["adjective"]
      @pronoun = options[:word_data]["part_of_speech"]["pronoun"]
      @preposition = options[:word_data]["part_of_speech"]["preposition"]
      @article = options[:word_data]["part_of_speech"]["article"]
      @conjunction = options[:word_data]["part_of_speech"]["conjunction"]
      @adverb = options[:word_data]["part_of_speech"]["adverb"]


      colors = [
              0xFF302F34, 
              0xFF08470B, 
              0xFF1D0A46
            ]

      @color = Gosu::Color.argb(colors.sample)
      @@window ||= options[:window]
      @@font ||= Gosu::Font.new(@@window, "visuals/ARCADE.TTF", 45)

      @column = rand(0..6)
      @row = 0
      
      @current_y = @row * GRID_IN_PIXELS
      @current_x = @column * GRID_IN_PIXELS

      @text_width = @@font.text_width(content)
      @width = find_width
      @height = @@font.height
      @border_width = 1

      @speed = 2
  end

  def check_type(word_type)
    eval(word_type)
  end

  def draw
    if content != 0
      x1 = current_x
      y1 = current_y
      x2 = x1 + @width
      y2 = y1
      x3 = x2
      y3 = y2 + GRID_IN_PIXELS - (@border_width * 2)
      x4 = x1 
      y4 = y3
      @@window.draw_quad(x1, y1, color, x2, y2, color, x3, y3, color, x4, y4, color, 2)
      @x_center = x1 + (@width - (@border_width * 2)) / 2
      @x_text = @x_center - @text_width / 2 
      @y_center = y1 + (GRID_IN_PIXELS - (@border_width * 2)) / 2
      @y_text = @y_center - @height / 2
      @@font.draw(content, @x_text, @y_text, 3)   
    end
  end


  def fall
    @current_y += speed
  end

  def move_right
    @current_x += GRID_IN_PIXELS
  end

  def move_left
    @current_x -= GRID_IN_PIXELS
  end

  def find_width
    cols = 1
    while @text_width > GRID_IN_PIXELS * cols
      cols += 1
    end
    if cols * GRID_IN_PIXELS <= @text_width + (GRID_IN_PIXELS / 2)
      cols += 1
    end
    cols * GRID_IN_PIXELS - 1
  end

  def collision_with_floor
    if current_y >= 550
      @speed = 0
    end
  end

  def collision_with_ceiling
    current_y <= 5
  end


  def top
    current_y
  end

  def bottom
    current_y + GRID_IN_PIXELS
  end

  def left
    current_x
  end

  def right 
    current_x + @width
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

