require 'pqueue'

Coord = Struct.new(:x, :y) do
  def w = Coord.new(x - 1, y)
  def n = Coord.new(x, y - 1)
  def e = Coord.new(x + 1, y)
  def s = Coord.new(x, y + 1)
end

QueueEntry = Struct.new(:coord, :est_dist)

def count_bits(n)
  sum = 0
  while n > 0
    sum += 1 if n & 1 == 1
    n >>= 1
  end
  sum
end

def even_parity?(n)
  count_bits(n).even?
end

def open_cell?(c, favorite)
  c.x >= 0 && c.y >= 0 && even_parity?(c.x*c.x + 3*c.x + 2*c.x*c.y + c.y + c.y*c.y + favorite)
end

def neighbors(coord, favorite)
  coord.w.tap { |c| yield c if open_cell?(c, favorite) }
  coord.n.tap { |c| yield c if open_cell?(c, favorite) }
  coord.e.tap { |c| yield c if open_cell?(c, favorite) }
  coord.s.tap { |c| yield c if open_cell?(c, favorite) }
end

def dist(a, b)
  (b.x - a.x).abs + (b.y - a.y).abs
end

def search(favorite, target)
  start = Coord.new(1, 1)
  best_dist_to = { start => 0 }
  fringe = PQueue.new { |a, b| a.est_dist < b.est_dist }
  fringe.push QueueEntry.new(start, dist(start, target))

  until fringe.empty?
    current = fringe.pop
    dist_so_far = best_dist_to[current.coord]
    return dist_so_far if current.coord == target

    dist_so_far += 1
    neighbors(current.coord, favorite) do |neighbor|
      if best_dist_to[neighbor].nil? || dist_so_far < best_dist_to[neighbor]
        best_dist_to[neighbor] = dist_so_far
        fringe.push QueueEntry.new(neighbor, dist_so_far + dist(neighbor, target))
      end
    end
  end

  nil
end

if ARGV.size < 3
  puts "usage: ruby 13.rb favorite target_x target_y"
  exit
end
favorite, target_x, target_y = ARGV.map(&:to_i)

puts search(favorite, Coord.new(target_x, target_y))
