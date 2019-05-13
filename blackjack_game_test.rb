require_relative './blackjack_helper'
require_relative 'BlackJack'
require 'minitest/autorun'

class BlackJackTest < Minitest::Test
  #dealer not busted and not blackjack
  def test_loser
    game = BlackJack.new
    game.dealer.hand.hit(Card.new('A', :spade))
    game.dealer.hand.hit(Card.new(9, :heart))

    loser = Minitest::Mock.new
    hand = Minitest::Mock.new
    2.times do
      loser.expect(:hand, hand)
      hand.expect(:bust, false)
      hand.expect(:points, 15)
    end 
    evener = Minitest::Mock.new
    e_hand = Minitest::Mock.new
    2.times do
      evener.expect(:hand, e_hand)
      e_hand.expect(:bust, false)
      e_hand.expect(:points, 20)
    end

    buster = Minitest::Mock.new
    b_hand = Minitest::Mock.new
    2.times do
      buster.expect(:hand, b_hand)
      b_hand.expect(:bust, true) 
      b_hand.expect(:points, 23)
    end

    game.players << loser << evener << buster

    test = game.send(:losers)
    
    assert test.length == 2
  end
end
