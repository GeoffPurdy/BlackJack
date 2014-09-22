require_relative 'Card.rb'

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
