
class Hand
  def initialize()
    @cards = [] 
  end

  def points
    aces = 0
    if busted?
      @cards.each do |card|
        if card.value == 'A'
          aces += 1
        end
      end
    end
    sum - (10 * aces)
  end

  def display
    spread = Array.new(7) {""}
    iterator = [*0..6]
    @cards.each do |card|
      iterator.each do |i|
        spread[i] += card.print_card[i]
      end
    end
    spread
  end

  def bust
    points > 21
  end

  def hit(card)
    @cards << card
  end
  
  private 
   
    def face_value(card)
      royals = ['K', 'Q', 'J']
      if royals.include?(card.value)
        10
      elsif card.value == 'A'
        11
      else
        card.value
      end
    end
  
    def sum
      total = 0
      if @cards.any?
        @cards.each do |card| 
          total += face_value(card) 
        end
      end
      total
    end

    def busted?
      sum > 21
    end
end
