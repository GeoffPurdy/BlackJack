require_relative 'Player.rb'
require_relative 'Card.rb'

class Strategy
  # trivial implementation of interface
  def initialize(players)
    @players = players
  end

  def bet
    return 10
  end

  def hit?
    return false
  end
end

class DealerStrategy < Strategy
  # to be implemented w/ dealer rules & constraints
  def hit?
    dealer = @players.first.show_hand
    opponent = @players.last.show_hand
    return (opponent < 22 && opponent > dealer && dealer < 17)
  end
end

class RandomStrategy < Strategy
  def bet
    return rand(1..10)
  end

  def hit?
    return rand(1).zero?
  end
end

class InteractiveStrategy < Strategy
  def bet
    puts "Puny Human bets 10.  House rules."
    return 10
  end

  def hit?
    p "Dealer has: " + @players.first.show_hand.to_s
    p "You have: "   + @players.last.show_hand.to_s
    p "Would you like to hit? Type 'y' to hit, anything else to stay: "
    @ans = gets.chomp.downcase
    return @ans =~ /^y/
  end
end
