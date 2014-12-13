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


class Blackjack
  attr_accessor :deck, :player, :dealer

  def initialize 
    @deck = Deck.new 
    @player = Player.new("Player1")
    @dealer = Dealer.new 
  end

  def set_player_name
    puts "What is your name?"
    answer = gets.chomp.capitalize

    player.name = answer 
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_hands
    player.show_hand
    dealer.show_hand
  end

  def check_players_cards
    if !player.is_busted?
      player_turn
    else
      puts "You busted! Dealer wins"
    end
  end


  def check_dealers_cards
    if !dealer.is_busted?
      puts "My sabaii"
    else
      puts "Dealer busts. You win!"
    end
  end

  def player_turn
    player.show_hand
    dealer.show_hand
    puts "What would you like to do? 1) Hit 2) Stay"
    answer = gets.chomp.to_i
 

    if answer == 1
      player.add_card(deck.deal_one)
      player.show_hand
      check_players_cards
    elsif answer == 2
      dealer_turn
    else answer != 1 || answer != 2
      puts "Please enter either a one or a two"
      player_turn
    end
  end

  def dealer_turn
    while dealer.total < 17
      dealer.add_card(deck.deal_one)
      check_dealers_cards
    end
  end

  def who_won?(player, dealer)
    if player.total > dealer.total && !player.is_busted? && !dealer.is_busted?
      puts "Congratulations. You beat the dealer"
    elsif dealer.total > player.total && !dealer.is_busted? && !player.is_busted?
      puts "Sorry you lose"
    else dealer.total == player.total && !player.is_busted? && !dealer.is_busted?
      puts "looks like a push"
    end
  end

  def play_again?
    puts "Would you like to play again? (Y/N)"
    answer = gets.chomp.upcase

    if answer == "Y"
      game = Blackjack.new 
      game.start
    else answer == "N"
      puts "Goodbye"
    end

  end


  def start
    set_player_name
    deal_cards
    player_turn
    dealer_turn
    dealer.show_hand
    who_won?(player, dealer)
    play_again?
  end
end

game = Blackjack.new 
game.start