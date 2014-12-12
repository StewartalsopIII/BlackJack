class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def pretty_output
    puts "The #{face_value} of #{find_suit}"
  end

  def find_suit
    rel_val = case suit
                when 'H' then 'Hearts'
                when 'D' then 'Diamonds'
                when 'S' then 'Spades'
                when 'C' then 'Clubs'
              end
    rel_val
  end

  def to_s
    pretty_output
  end

end

class Deck
  attr_accessor :cards 

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop 
  end

  def size
    cards.size
  end
end


module Hand
  def show_hand
    puts "-----#{name}'s Hand-----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    face_values = cards.map {|card| card.face_value}

    total = 0
    face_values.each do |val|
      if val == "A"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    #correct for aces
    face_values.select{|val| val == "A"}.count.times do 
      break if total <= 21
      total -= 10
    end

    total 
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > 21
  end
end

class Player
  include Hand
  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end  

end


class Game
  #create a new deck
  #deal cards to player and dealer
  #show cards to player
  #ask player if they want to hit or stay 
  #if the player says hit, hit until they say stay or go bust
  #check dealers cards to see if above 17 or not
  #if dealers cards add up to less than 17, deal cards until they go bust or are over 17
  #once player has stayed and dealer has more than 17 compare cards to see who wins
  
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new 
    @player = Player.new("player1")
    @dealer = Dealer.new
  end
  
  def get_name
    puts "What is your name"
    new_name = gets.chomp
    player.name = new_name
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_hand
    dealer.show_hand  
  end

  def hit_or_stay
    loop do 
      puts "Would you like to hit or stay? (H/S)"
      answer = gets.chomp.upcase
      break if answer != "H"

      player.add_card(deck.deal_one)
      player.show_hand
      if player.is_busted?
        puts "Sorry you have more than 21"
        puts "You lose, sucker!"
        break
      end
    end
  end

  def dealer_turn
    while dealer.total < 17
      dealer.add_card(deck.deal_one)
      dealer.show_hand
      if dealer.is_busted?
        puts "Congratulations Dealer has over 21. You win!"
        break
      end
    end until dealer.total >= 17
  end

  def compare_cards
    if dealer.total > player.total && dealer.total <= 21
      puts "Sorry dealer wins. You lose"
    elsif player.total > dealer.total
      puts "You beat the dealer"
    else player.total == dealer.total 
      puts "Its a tie!"
    end
  end

  def play_again
    puts "Would you like to play again? (Y/N)"
    answer = gets.chomp.upcase

    while answer == "Y"
      Game.new.play 
    end
  end

  def play
    get_name
    deal_cards
    show_flop
    hit_or_stay
    dealer.show_hand
    dealer_turn
    compare_cards
    play_again  
  end
end

Game.new.play 


