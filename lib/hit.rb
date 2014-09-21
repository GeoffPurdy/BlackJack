def hit?
  ans = nil
  puts "Would you like to hit? (y/n)"
  p "entering loop ans=" + ans.to_s + "\n"
  while ('n' != ans || 'y' != ans)
    p "looping ans=" + ans.to_s + "\n"
    ans = gets.chomp
    puts "You answered: " + ans.to_s + "\n"
  end
  p "exiting loop ans=" + ans.to_s + "\n"
  return 'y' == ans ? true : false
end

answer = hit?
p answer
