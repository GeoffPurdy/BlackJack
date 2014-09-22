require_relative 'Strategy.rb'
require_relative 'Card.rb'
require_relative 'Player.rb'
require_relative 'Deck.rb'

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
      # each player gets two cards
      2.times do
        @players.each{ |player| player.save_card(@deck.pop) }
      end
      # each player places a bet
      @players.each{ |player| @pot += player.place_bet }
      # each player hits until stays
      @players.each{ |player|
        while (player.hit? and player.show_hand < @BLACKJACK && !@deck.empty?) do
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
