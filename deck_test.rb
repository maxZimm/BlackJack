require './Deck'
require 'minitest/autorun'

class DeckTest < Minitest::Test
  def test_deck
    # test that new deck is empty
    deck = Deck.new()
    assert deck.stack.length == 0

    # test that filled deck is correct amount of cards
    deck = Deck.new()
    deck.make_deck
    assert deck.stack.length == 52
  end
end
