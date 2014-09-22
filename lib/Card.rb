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
