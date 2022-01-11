require 'set'
DX = [0, 1, 0, -1]
DY = [1, 0, -1, 0]
x, y = 0, 0
dir = 0
visited = Set.new
ARGF.readline.split(", ").each do |step|
  dir = (dir + (step[0] == 'L' ? -1 : 1)) & 3
  dist = step[1..].to_i
  dist.times do
    x += DX[dir]
    y += DY[dir]
    if visited.include?([x, y])
      puts x.abs + y.abs
    end
    visited << [x, y]
  end
end
puts x.abs + y.abs
