require_relative 'Card.rb'
require_relative 'Strategy.rb'

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
