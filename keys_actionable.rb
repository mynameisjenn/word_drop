module KeysActionable

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

  
  def button_down_end(id)
    if id == Gosu::KbP
      initialize_game
    elsif id == Gosu::KbQ
      close
    end      
  end

end