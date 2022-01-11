KEYPAD=[%w[_ _ 1 _ _], %w[_ 2 3 4 _], %w[5 6 7 8 9], %w[_ A B C _], %w[_ _ D _ _]]
x, y = 0, 2
ARGF.each_line do |line|
  line.chars.each do |char|
    case char
    when 'U'; y -= 1 if y > 0 && KEYPAD[y - 1][x] != '_'
    when 'D'; y += 1 if y < 4 && KEYPAD[y + 1][x] != '_'
    when 'L'; x -= 1 if x > 0 && KEYPAD[y][x - 1] != '_'
    when 'R'; x += 1 if x < 4 && KEYPAD[y][x + 1] != '_'
    end
  end
  print KEYPAD[y][x]
end
puts
