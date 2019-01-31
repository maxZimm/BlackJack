#require './blackjack_helper'
require './Hand'
require './Card'
require 'minitest/autorun'

class HandTest < Minitest::Test

  def test_points
    # test that an empty hand is calculated correctly
    hand = Hand.new() 
    assert hand.points == 0 
    # test that 1 card is accurately calculated    
    hand = Hand.new()
    hand.hit(Card.new(2, :hearts))
    assert hand.points == 2 

    # test that more than one card in a hand is accuratley calculated 
    hand = Hand.new()
    hand.hit(Card.new(2, :hearts)) 
    hand.hit( Card.new(3, :clubs))
    assert hand.points == 5

    # test that a hand with a face card is calculated correctly
    hand = Hand.new()
    hand.hit(Card.new('K', :diamonds))
    assert hand.points == 10

    # test that ace is evaluated as 1, when 11  will bust 
    hand = Hand.new()
    hand.hit(Card.new('Q', :spades))
    hand.hit(Card.new(10, :hearts))
    hand.hit(Card.new('A', :spades))
    assert hand.points == 21

    # test that ace is evaluated as 11, when it won't bust
    hand = Hand.new()
    hand.hit(Card.new('A', :hearts))
    hand.hit(Card.new(5, :diamonds)) 
    assert hand.points == 16

    # test that 2 aces are evaluated as 12
    hand = Hand.new()
    hand.hit(Card.new('A', :spades))
    hand.hit(Card.new('A', :hearts))
    assert hand.points == 2

  end

  def test_busted
    # test hand with less than 21 points does not bust 
    hand = Hand.new()
    hand.hit(Card.new('A', :hearts))
    hand.hit(Card.new(5, :diamonds)) 
    assert hand.bust == false
    assert hand.points == 16

    # test hand with 21 points does not bust
    hand = Hand.new()
    hand.hit(Card.new('Q', :spades))
    hand.hit(Card.new('A', :spades))
    assert hand.points == 21
    assert hand.bust == false


    # test hand with more than 21 points does bust
    hand = Hand.new()
    hand.hit(Card.new('Q', :spades))
    hand.hit(Card.new('K', :spades))
    hand.hit(Card.new(4, :clubs))
    assert hand.points == 24
    assert hand.bust == true
  end

  def test_display
    # test that display holds all cards in the hand
    hand = Hand.new()
    hand.hit(Card.new(5, :diamonds))
    assert hand.display.length == 7

    # test that each card in display is a printable card
    hand = Hand.new()
    hand.hit(Card.new('Q', :spades))
    hand.hit(Card.new('K', :spades))
    hand.hit(Card.new(4, :clubs))
    display = hand.display
    assert display.length == 7
    assert display[1].include?("Q") == true 
    assert display[1].include?("\u2660") == true 
    assert display[1].include?("K") == true 
    assert display[1].include?("\u2660") == true 
    assert display[1].include?("4") == true 
    assert display[1].include?("\u2663") == true 
   
  end
end
