require './Player'
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
    # Test that a player can view hand
    card1 = Card.new(5, :clubs)
    card2 = Card.new(6, :diamonds)
    card3 = Card.new(7, :hearts)
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
    # Test that a player can recieves move message for 2 cards
    input = StringIO.new()
    input.puts 'H'
    input.rewind
    $stdin = input
    assert_output("\nYour action [S]tand, [H]it, [D]ouble down?: ") { player.move }
    # Test that a player can double down
    input = StringIO.new()
    input.puts 'D'
    input.rewind
    $stdin = input
    assert player.move == 'd' 
    # Test that a player can recieve move message for 3+ cards
    input = StringIO.new()
    input.puts 'H'
    input.rewind
    $stdin = input
    player.hand.hit(card3)
    assert_output("\nYour action [S]tand, [H]it: ") { player.move }
    # Test that a player can send hit message
    input = StringIO.new()
    input.puts 'H'
    input.rewind
    $stdin = input
    assert player.move == 'h'
   # Test that a player can send a stand message 
    input = StringIO.new()
    input.puts 'S'
    input.rewind
    $stdin = input
    assert player.move == 's' 
  end
end
