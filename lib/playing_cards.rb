#Encoding: UTF-8

# 1F0A 1F0B 1F0C 1F0D
# 0
# .
# .
# E
ary = []
cols = (0x1F0A..0x1F0D)
rows = (0x1..0xE).to_a
rows.delete(0xC) # C = Knight LOL  Delete it!

cols.each do |i|
  rows.each do |j|
    ary << (i.to_s(16) + j.to_s(16)).hex
  end
end
