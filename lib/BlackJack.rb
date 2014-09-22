class Card
  # Unicode 6.0+ Playing Cards http://www.unicode.org/charts/PDF/U1F0A0.pdf
  # 0x1F0A..0x1F0D by 0x1..0xE matrix
  attr_accessor :is_visible
  attr_reader   :hex_code

  def initialize(hex_code)
    @is_visible = false
    @hex_code = hex_code
  end

  def value
    val = @hex_code % 0x10        # ones hex digit of unicode code is rank
    return val <= 0x9 ? val : 0xA # translate rank to value
  end
end

class Deck
  attr_reader :is_shuffled

  def initialize
    @is_shuffled = false
    @cards = []

    # iterate over 2D array of hex prefixes and suffixes to build unicode deck
    cols = (0x1F0A..0x1F0D) # Hex prefix for unicode 6.0+ playing card suit
    rows = (0x1..0xE).to_a  # Hex suffix for unicode 6.0+ playing card rank
    rows.delete(0xC)        # C = unicode Knight We don't use it. Delete!

    cols.each do |i|
      rows.each do |j|
        @cards << Card.new((i.to_s(16) + j.to_s(16)).hex) # strcat & conv to hex
      end
    end
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
    @hand.each { |h| sum += h.value }
    return sum
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

  def has_money?
    return @money > 0
  end
end

class BlackJack
  def initialize(blackjack, num_players)
    @BLACKJACK = blackjack
    @CARDS_IN_DECK = 52
    @deck = Deck.new
    @pot = 0
    @players = []
    @table = []

    num_players.times { |n|
      if(0 == n) # first player is arbitrarily dealer
        @players[n] = Player.new(true, DealerStrategy.new(@players), 100)
      else
        @players[n] = Player.new(false, InteractiveStrategy.new(@players), 100)
      end
    }
  end

  def play
    @deck.shuffle!
    # create players
    while (@deck.has_cards?(@players.size) && @players.last.has_money?)
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
        # score over blackjack => Busted => lose bet
        score > @BLACKJACK ? @table.push(0) : @table.push(player.show_hand)
        player.destroy_hand
      }
      # winner collects pot; taking index works only b/c dealer goes first
      winner = @table.index(@table.max)
      print "Player " + winner.to_s + " wins $" + @pot.to_s + "\n\n\n\n\n"
      @players[ winner ].exchange_money(@pot) # FIXME this seems problematic
      @pot = 0
      @table = [] # results don't carry over => clear table
    end
  end

  def results
    return "Dealer: $" + @players.first.money.to_s +
    "\nPlayer: $" + @players.last.money.to_s
  end

  def to_s
    return self.inspect
  end

end


bj = BlackJack.new(21,2)
puts "starting game"
bj.play
puts "game over"
print bj.results + "\n\n\n"
