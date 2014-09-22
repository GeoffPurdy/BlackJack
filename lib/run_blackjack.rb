require_relative 'BlackJack.rb'

bj = BlackJack.new(21,2)
puts "starting game"
bj.play
puts "game over"
print bj.results + "\n\n\n"
