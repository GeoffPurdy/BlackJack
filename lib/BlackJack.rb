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
    @card = [1..num_cards]
  end

  def empty?
    return @card.empty?
  end

  def has_cards?(n)
    return @card.size >= n
  end

  def shuffle!
    if (!is_shuffled)
       @card.shuffle!
       @is_shuffled = true
    end
  end

  def pop(n)
    return @card.pop(n)
  end

  def pop
    return self.pop(1)
  end
end

class Player
  attr_reader :is_dealer
  attr_accessor :money

  def initialize(is_dealer, strategy, money)
    @is_dealer = is_dealer
    @strategy = strategy
    @money = money
    @hand = Array.new
  end

  def place_bet
    bet = @money.zero? ? 0 : 1
    self.exchange_money(-bet)
  end

  def show_hand
    sum = 0
    return @hand.each { |n| sum += @hand[n] }
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
      @players.each{ |p| @players[p].save_card(@deck.pop) }
      # each player places a bet
      @players.each{ |p| @pot += @players[p].place_bet }
      # players reveal cards
      @players.each{ |p| @table.push(@players[p].show_hand)}
      # winner collects pot
      @player[ @table.each_with_index.max ].exchange_money(@pot)
      @pot = 0
    end
  end

  def results
    @players.each
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
print g.to_s + "\n\n\n"