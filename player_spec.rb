require './Player'
require './Hand'
require './Card'
require 'minitest/autorun'

class PlayerTest < Minitest::Test

  def test_player
    # Test that a player has a name 
    player = Player.new('Miguel')
    assert player.name == 'Miguel'
    
    # Test that a new player has an empty hand
    assert player.hand.class == Hand 
    assert player.hand.points == 0

    # Test that a player has a purse
    assert player.purse == 100
    # Test that a player can make a bet
    player.bet(10)
    assert player.purse == 90 
    # Test that a player can't bet more than they have
    assert player.bet(100) == "you don't got the dough"
    # Test that a player can view hand
    card1 = Card.new(5, :clubs)
    card2 = Card.new(6, :diamonds)
    player.hand.hit(card1)
    player.hand.hit(card2)
    assert_output( card1.print_card[0] + card2.print_card[0] + "\n" +
card1.print_card[1] + card2.print_card[1] + "\n" +
card1.print_card[2] + card2.print_card[2] + "\n" +
card1.print_card[3] + card2.print_card[3] + "\n" +
card1.print_card[4] + card2.print_card[4] + "\n" +
card1.print_card[5] + card2.print_card[5] + "\n"+ 
card1.print_card[6] + card2.print_card[6] + "\n" + 
"#{player.hand.points}\n") { player.print_hand } 
    # Test that a player can stand
    assert_output() { player.move }
    # Test that a player can hit 
    # Test that a player can double down
  end
end
