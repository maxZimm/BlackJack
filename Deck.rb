require './Card'

class Deck
  attr_accessor :stack

  def initialize()
    @stack = []  
  end

  def make_deck
    make_suite(:hearts)
    make_suite(:clubs)
    make_suite(:diamonds)
    make_suite(:spades)
    @stack.shuffle!
  end
  
  private

    def make_suite(suite)
      non_face = [*2..10]
      face = ["A","J","Q","K"]
      face.concat(non_face)
      face.each do |value|
        @stack << Card.new(value, suite)
      end
    end
end
