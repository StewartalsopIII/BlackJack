#ps

# 1. ask the player their name
# 2. deal 2 cards to the player
# 3. deal 2 cards to the dealer
# 4. calculate players cards
# 5. ask the player if they want to hit or stay
# 6. if player stays, then calcualate dealers cards and see if they add up to 17
# 7. if dealers cards do not add up to 17, keep dealing cards to the dealer until they hit 17
# 8. if player hits then deal another card 
# 9. calculate the players cards
# 10. ask the player if they want to hit or stay 
# 11. if 


def calculate_total(cards)
  arr = cards.map {|x| x[1]}

  total = 0
  arr.each do |value|
    if value == "A"
      total += 11
    elsif value.to_i == 0
      total += 10
    else
      total += value.to_i
    end
  end

  #correct for A: if value is above 21 every A becomes 1

  arr.select{|e| e == "A"}.count.times do 
    total -= 10 if total > 21
  end

  total
end


suits = ["H", "S", "C", "D"]
cards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

deck = suits.product(cards)
deck.shuffle!

# Deal Cards

mycards = []
dealercards = []

mycards << deck.pop
dealercards << deck.pop
mycards << deck.pop
dealercards << deck.pop

dealertotal = calculate_total(dealercards)
mytotal = calculate_total(mycards)

# Show Cards

puts "Dealer has: #{dealercards[0]} and #{dealercards[1]}, for a total of: #{dealertotal}"
puts "You have: #{mycards[0]} and #{mycards[1]} for a toal of: #{mytotal}"
puts ""

# Player turn

if mytotal == 21
  puts "Congratulations you hit blackjack! You win!"
  exit
end

while mytotal < 21
  puts "What would you like to do? 1) hit 2) stay"
  hit_or_stay = gets.chomp
  
  if !['1', '2'].include?(hit_or_stay)
    puts "Error: you must enter 1 or 2"
    next
  end

  if hit_or_stay == "2"
    break
  end

  new_card = deck.pop
  puts "Dealing card to player: #{new_card}"
  mycards << new_card
  mytotal = calculate_total(mycards)
  puts "Your total is now #{mytotal}"

  if mytotal == 21
    puts "Congratulations. You hit blackjack! You win!"
    exit
  elsif mytotal > 21
    puts "Sorry you busted. You lose"
    exit
  end
end

# Dealer turn


if dealertotal == 21
  puts "Sorry, dealer hit blackjack. You lose."
  exit
end

while dealertotal < 17
  #hit
  new_card = deck.pop
  puts "Dealing dealer a new card: #{new_card}"
  dealercards << new_card
  dealertotal = calculate_total(dealercards)
  puts "Dealer total is now: #{dealertotal}"

  if dealertotal == 21
    puts "Sorry, dealer hit blackjack. You lose"
    exit
  elsif dealertotal > 21
    puts "Dealer busted. Congratulations! You won!"
    exit
  end
end

#Compare hands

puts "Dealers cards: "
dealercards.each do |card|
  puts "=> #{card}"
end
puts ""

puts "Your cards: "
mycards.each do |card|
  puts "=> #{card}"
end
puts ""


if dealertotal < mytotal
  puts "Congratulations, you win!" 
elsif dealertotal > mytotal
  puts "Sorry. Dealer wins. You lose"
else
  puts "Its a tie"
end

exit
            


