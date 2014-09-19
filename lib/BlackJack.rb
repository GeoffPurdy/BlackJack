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

class Player
  attr_reader :is_dealer
  attr_accessor :money

  def initialize(is_dealer, strategy, money)
    @is_dealer = is_dealer
    @strategy = strategy
    @money = money
    @hand = []
  end

  def place_bet
    bet = @money.zero? ? 0 : 1
    self.exchange_money(-bet)
    return bet
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
  def initialize(num_players)
    @players = []
    @deck = Deck.new(52)
    @pot = 0
    @table = []

    num_players.times { |n|
      if(0 == n) # first player is arbitrarily dealer
        @players[n] = Player.new(true, "DealerStrategy", 100)
      else
        @players[n] = Player.new(true, "DumbStrategy", 100)
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
      # players reveal cards
      @players.each{ |player|
        @table.push(player.show_hand)
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

puts "Would you like to play a game of BlackJack?"
g = Game.new(2)
print g.to_s + "\n\n\n"
puts "starting game"
g.play
puts "game over"
print g.results + "\n\n\n"
