module GameActionable

  def initialize_game

    @mag_glass = Gosu::Image.new('visuals/hand.png')
    @score = Score.new(self, @x, @y, 2)
    @level = Level.new(self, @x, @y, 2)

    @count = 0
    @background = Gosu::Image.new('visuals/back.png')

    @game_music = Gosu::Song.new('sounds/sequence-8-bit-music-loop.wav')
    @game_music.play(looping = true)
    @impact = Gosu::Sample.new('sounds/swooshy-fight-straight-hit.wav')
    @correct_sound = Gosu::Sample.new('sounds/laser.wav')
    @level_up_sound = Gosu::Sample.new('sounds/blip2.wav')
    @scene = :game
    
    @level_up = false
    @word_list = WordList.new
  end

  def update_game

    new_word = true

    @word_list.each do |word|
      word.fall
      p word.speed
      p word.current_y
      p word.current_x
    end

    check_for_collision

    @word_list.each do |word|
      new_word = false if word.speed != 0
    end


    if new_word 
      @word_list << @hidden_list.shift
    end

    if @hidden_list.length <= 15
      get_words_from_grammarslayer
    end

    if @count >= 15
      level_up
    end

    if @count >= 4
      level_up
    end 

    if @count >= 6
      level_up
    end 

    if @count >= 8
      level_up
    end 

    if @count >= 10
      level_up
    end

    if @count >= 12
      level_up
    end

    if @count >= 14
      level_up
    end

  

    initialize_end(:too_many_words) if stacked_too_high?     
  end

  def draw_game
    @word_list.each do |word|
      word.draw
    end
    @mag_glass.draw(mouse_x, mouse_y, 3)
    @score.draw_game
    @prompt.draw
    @background.draw(0, 0, 0)
    @level.draw_game
  end

  def stacked_too_high?
    collided_words = @word_list.select do |word|
      @word_list.select { |compare_word| word.collision_with_block(compare_word) }.any?
    end
    collided_words.select { |word| word.collision_with_ceiling }.any?
  end


end