#Encoding: UTF-8

# Unicode 6.0+ Playing Cards http://www.unicode.org/charts/PDF/U1F0A0.pdf
# 0x1F0A..0x1F0D by 0x1..0xE matrix

deck = []
cols = (0x1F0A..0x1F0D)
rows = (0x1..0xE).to_a
rows.delete(0xC) # C = Knight LOL  Delete it!

cols.each do |i|
  rows.each do |j|
    deck << (i.to_s(16) + j.to_s(16)).hex
  end
end
