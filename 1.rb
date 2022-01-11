DX = [0, 1, 0, -1]
DY = [1, 0, -1, 0]
x, y = 0, 0
dir = 0
ARGF.readline.split(", ").each do |step|
  dir = (dir + (step[0] == 'L' ? -1 : 1)) & 3
  dist = step[1..].to_i
  x += DX[dir] * dist
  y += DY[dir] * dist
end
puts x.abs + y.abs
