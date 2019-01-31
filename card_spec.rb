require '../card'
require 'minitest/autorun'

class CardTest < Minitest::Test
  def test_new_card
    new_card = Card.new(4, :hearts)
    assert new_card.value == 4
    assert new_card.suit == "\u2665" 
    print = new_card.print_card
    assert print.class == Array
    assert print.length == 7
    assert print[0].length == 10
    assert print[1].length == 10
    assert print[2].length == 10
    assert print[3].length == 10
    assert print[4].length == 10
    assert print[5].length == 10
    assert print[6].length == 10
  end

  def test_new_face_card
    new_card = Card.new('A', :spades)
    assert new_card.value == 'A'
    assert new_card.suit == "\u2660"
  end
  
  def test_ten_card
    new_card = Card.new(10, :clubs)
    print = new_card.print_card  
    assert print.length == 7   
    assert print[0].length == 10
    assert print[1].length == 10
    assert print[2].length == 10
    assert print[3].length == 10
    assert print[4].length == 10
    assert print[5].length == 10
    assert print[6].length == 10
  end
end
