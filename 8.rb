screen = 6.times.map { ["."] * 50 }
ARGF.each_line do |line|
  if line =~ /rect (\d+)x(\d+)/
    w, h = [$1, $2].map(&:to_i)
    (0...h).each do |y|
      (0...w).each do |x|
        screen[y][x] = '#'
      end
    end
  elsif line =~ /rotate row y=(\d+) by (\d+)/
    y, n = [$1, $2].map(&:to_i)
    screen[y].rotate!(-n)
  elsif line =~ /rotate column x=(\d+) by (\d+)/
    x, n = [$1, $2].map(&:to_i)
    vals = screen.map { |row| row[x] }.rotate(-n)
    vals.each_with_index do |v, i|
      screen[i][x] = v
    end
  end
  puts screen.map(&:join)
  puts
end

puts screen.map { |row| row.count('#') }.sum
