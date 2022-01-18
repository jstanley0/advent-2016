require 'set'

class TSP
  attr_accessor :graph

  def initialize
    @graph = {}
  end

  def load_maze
    maze = ARGF.each_line.to_a
    maze.each_with_index do |row, y|
      row.chars.each_with_index do |char, x|
        if ('0'..'9').include?(char)
          compute_distances_from(maze, x, y)
        end
      end
    end
  end

  # essentially do a flood fill from the given starting point
  # and count how many steps it took to reach each other number
  def compute_distances_from(maze, x, y)
    maze = maze.map(&:dup)

    src = maze[y][x].to_i
    maze[y][x] = '.'

    @graph[src] = {}
    fringe = [[x, y]]
    dist = 0
    until fringe.empty?
      next_fringe = Set.new
      fringe.each do |x, y|
        c = maze[y][x]

        @graph[src][c.to_i] = dist if ('0'..'9').include?(c)

        next_fringe << [x, y - 1] unless '# '.include? maze[y - 1][x]
        next_fringe << [x - 1, y] unless '# '.include? maze[y][x - 1]
        next_fringe << [x, y + 1] unless '# '.include? maze[y + 1][x]
        next_fringe << [x + 1, y] unless '# '.include? maze[y][x + 1]

        maze[y][x] = ' '
      end
      fringe = next_fringe
      dist += 1
    end
  end

  def solve
    points_to_visit = @graph.keys - [0]
    best = 1e10
    points_to_visit.permutation do |order|
      from = 0
      cost = 0
      order.each do |point|
        cost += @graph[from][point]
        from = point
      end
      cost += @graph[from][0]
      best = cost if cost < best
    end
    best
  end
end

tsp = TSP.new
tsp.load_maze
pp tsp.graph
puts tsp.solve

