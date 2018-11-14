class Player
  attr_reader :type, :bust, :sum, :black_jack
  attr_accessor :hand, :purse, :bet

  def initialize type
    @hand = []
    @type = type
    @purse = 100
    @black_jack = false
  end

  def print_card(denom)
    denom[1].each {|x| print x }
    print "\n"
    denom[2].each {|x| print x }
    print "\n"
    2.times do
      denom[3].each {|x| print x }
      print "\n"
    end
    denom[4].each {|x| print x }
    print "\n"
    denom[5].each {|x| print x }
    print "\n"
  end

  def print_hand
    puts @type
    @hand.each {|card| card[1].each {|x| print x }}
    print "\n"
    @hand.each {|card| card[2].each {|x| print x }}
    print "\n"
    2.times do
      @hand.each {|card| card[3].each {|x| print x }}
      print "\n"
    end
    @hand.each {|card| card[4].each {|x| print x }}
    print "\n"
    @hand.each {|card| card[5].each {|x| print x }}
    print "\n"
    puts @sum.to_s
  end

  def check_hand
    face = ["A","J","Q","K"]
    sum = 0
    @black_jack = false
    @hand.each do |card|
      card = card[0][0..-2]
      if face.include?(card)
        if card == "A"
          sum += 11
        else
          sum += 10
        end
      else
        sum += card.to_i
      end
    end

    sum = check_sum(@hand, sum)
    if sum > 21
      @bust = true
    elsif sum == 21 && @hand.length == 2
      print "BlackJack! "
      @black_jack = true
      @bust = false
    else
      @bust = false
    end
    @sum = sum
  end

  def check_sum(hand, sum)
    #go through hand to see if sum is greater than 21, if true check if any aces and re-evaluate with Ace == 1
    if sum > 21
      hand.each do |card|
        card = card[0][0..-2]
        if card == "A"
          sum -= 10
        end
      end
    end
    sum
  end
end