class Card
  VALUES = %w( 2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w( Hearts Spades Clubs Diamonds )

  attr_accessor :value, :suit
  
  def initialize(value, suit)
    @value = value
    @suit = suit
  end
end

class Deck
  def initialize
    @deck = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        @deck << [suit, value]
      end
    end
    @deck.shuffle!
  end

  def deal_card
    @deck.pop
  end
end

class Participant
  attr_accessor :name, :hand

  def initialize(name, hand)
    @name = name
    @hand = []
  end
end

class Player < Participant
end

class Dealer < Participant
end

a = Participant.new("Stewart", [])

a.deal_card
puts a.inspect

b = Deck.new

puts b.inspect  


