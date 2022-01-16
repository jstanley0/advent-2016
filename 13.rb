require 'set'

Coord = Struct.new(:x, :y) do
  def w = Coord.new(x - 1, y)
  def n = Coord.new(x, y - 1)
  def e = Coord.new(x + 1, y)
  def s = Coord.new(x, y + 1)
end

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

def search(favorite)
  start = Coord.new(1, 1)
  visited = Set.new
  visited << start

  fringe = [start]

  50.times do
    next_step = []

    fringe.each do |c|
      neighbors(c, favorite) do |neighbor|
        unless visited.include?(neighbor)
          visited << neighbor
          next_step << neighbor
        end
      end
    end

    fringe = next_step
  end

  visited.size
end

puts search(ARGV.first&.to_i || 10)
