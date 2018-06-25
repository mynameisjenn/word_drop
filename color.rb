require 'gosu'

class Color
  
  def initialize(window)
    @@colors ||= { purple: Gosu::Color.argb(0xaa624CD1), 
                   green: Gosu::Color.argb(0xaa00ff00),
                   blue: Gosu::Color.argb(0xaa0000ff) 
                 }
    end    
end


