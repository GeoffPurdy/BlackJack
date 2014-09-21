class Bet
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

class Chip
  attr_accessor :color
  attr_accessor :value

  def initialize(color, value)
    @color = color
    @value = value
  end
end

class Card
  attr_accessor :suit
  attr_accessor :rank
  attr_accessor :is_visible

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @is_visible = false
  end

  def value
    return @is_visible ? @value : nil
  end
end

class Deck
  attr_reader :is_shuffled

  def initialize(num_cards)
    @CARD_VALUES = [1,2,3,4,5,6,7,8,9,10,10,10,10] #A,1,2,3,4,5,6,7,8,9,10,J,Q,K
    # populate the deck
    @deck_values = []
    (num_cards / @CARD_VALUES.size).times do @deck_values.push(*@CARD_VALUES) end
    @num_cards = num_cards
    @is_shuffled = false
    @cards = []
    @num_cards.times { |n| @cards[n] = Card.new(n, "x") }
  end

  def empty?
    return @cards.empty?
  end

  def has_cards?(n)
    return @cards.size >= n
  end

  def shuffle!
    if (!is_shuffled)
       @cards.shuffle!
       @is_shuffled = true
    end
  end

  def pop
    return @cards.pop
  end
end

class Strategy
  # trivial implementation of interface
  def bet
    return 1
  end
  def hit?
    return false
  end
end

class DealerStrategy < Strategy
  def bet
    return 0
  end
end

class BrainlessStrategy < Strategy
  def bet
    return 2
  end
  def hit?
    return true
  end
end

class PunyHumanStrategy < Strategy
  def bet
    @amt = nil
    puts "Puny Human bets 10.  House rules."
#    while (@amt and @amt.to_i != 0 and "0" != @amt)
#      @amt = gets.chomp
#    end
    return 10 # @amt.to_i
  end

  def hit?
    @ans = nil
    p "Would you like to hit? Type 'y' to hit, anything else to stay: "
    @ans = gets.chomp.downcase
    return @ans =~ /^y/
  end
end


class Player
  attr_reader   :is_dealer
  attr_accessor :money

  def initialize(is_dealer, strategy, money)
    @is_dealer = is_dealer
    @strategy = strategy
    @money = money
    @hand = []
  end

  def place_bet
    bet = @strategy.bet
    self.exchange_money(-bet)
    return bet
  end

  def hit?
    return @strategy.hit?
  end

  def show_hand
    sum = 0
    return @hand.size { |h| sum += @hand[h].rank }
  end

  def destroy_hand
    @hand = []
  end

  def save_card(card)
    @hand.push(card)
  end

  def exchange_money(amount)
    @money += amount
  end
end

class Game
  def initialize(blackjack, num_players)
    @BLACKJACK = blackjack
    @CARDS_IN_DECK = 52
    @players = []
    @deck = Deck.new(@CARDS_IN_DECK)
    @pot = 0
    @table = []

    num_players.times { |n|
      if(0 == n) # first player is arbitrarily dealer
        @players[n] = Player.new(true, DealerStrategy.new, 100)
      else
        @players[n] = Player.new(true, PunyHumanStrategy.new, 100)
      end
    }

  end

  def play
    @deck.shuffle!
    # create players
    while @deck.has_cards?(@players.size)
      # each player gets a card
      @players.each{ |player| player.save_card(@deck.pop) }
      # each player places a bet
      @players.each{ |player| @pot += player.place_bet }
      # each player hits until stays
      @players.each{ |player|
        while (player.hit? and player.show_hand < @BLACKJACK) do
          player.save_card(@deck.pop)
        end
      }
      # each player reveals cards
      @players.each{ |player|
        score = player.show_hand
        # score over blackjack => Busted!
        score > @BLACKJACK ? @table.push(0) : @table.push(player.show_hand)
        player.destroy_hand
      }
      # winner collects pot
      @players[ @table.index(@table.max) ].exchange_money(@pot)
      @pot = 0
    end
  end

  def results
    return @players.inspect
  end

  def to_s
    return self.inspect
  end

end

class BlackJack
  def run
    fail "You need to add some functionality here before you can use this."
  end
end

g = Game.new(21,2)
puts "starting game"
g.play
puts "game over"
print g.results + "\n\n\n"
