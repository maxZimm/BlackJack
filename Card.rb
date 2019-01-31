class Card
  attr_reader :value, :suit
  
  def initialize(value, suit) 
    @suits = {hearts: "\u2665", diamonds: "\u2666", spades: "\u2660", clubs: "\u2663"}

    @value = value 
    @suit = @suits[suit] 
  end

  def print_card
    [top_line, value_line_left, blank_line, blank_line, blank_line, value_line_right, bottom_line]
  end

  private

    def top_line
      "|" + "\u203E" *8 + "|"
    end

    def bottom_line
      "|" + "_"*8 + "|"
    end

    def value_line_left
      if @value == 10
        "|#{@value}#{@suit}" + " " * 5 + "|" 
      else
        "|#{@value}#{@suit}" + " " * 6 + "|"
      end
    end
   
   def value_line_right
      if @value == 10
        "|" + " " * 5 + "#{@value}#{@suit}|" 
      else
        "|" + " " * 6 + "#{@value}#{@suit}|"
      end
    end
  
  def blank_line
    "|" + " "*8 + "|" 
  end
end
