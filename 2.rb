KEYPAD=[[1,2,3],[4,5,6],[7,8,9]]
x, y = 1, 1
ARGF.each_line do |line|
  line.chars.each do |char|
    case char
    when 'U'; y -= 1 if y > 0
    when 'D'; y += 1 if y < 2
    when 'L'; x -= 1 if x > 0
    when 'R'; x += 1 if x < 2
    end
  end
  print KEYPAD[y][x]
end
puts
