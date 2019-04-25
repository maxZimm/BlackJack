require './Hand'

class Player
  attr_reader  :name
  attr_accessor :hand, :purse, :betted

  def initialize(name)
    @hand = Hand.new 
    @name = name
    @purse = 100
  end

  def bet(amount)
      @betted = amount
  end

  def print_hand
    @hand.display.each {|line| puts line}
    puts @hand.points
  end

  def move
    if @hand.cards.length == 2
      print "\nYour action [S]tand, [H]it, [D]ouble down?: "
    else
      print "\nYour action [S]tand, [H]it: "
    end
    resp = gets.chomp.downcase
    if ['s', 'h', 'd'].include?(resp) && @hand.cards.length == 2
      return resp
    elsif ['s', 'h'].include?(resp)  && @hand.cards.length > 2
      return resp
    else
      print "Not recognized try again" 
      sleep(1.5)
      move 
    end
  end
end
