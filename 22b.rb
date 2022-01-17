require 'curses'

Node = Struct.new(:size, :used)
nodes = {}

ARGF.each_line.map do |line|
  if line =~ %r{/dev/grid/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)%}
    x, y = [$1, $2].map(&:to_i)
    nodes[[x, y]] = Node.new(*[$3, $4].map(&:to_i))
  end
end

puts "size range (excl whales): " + Range.new(*nodes.values.map(&:size).reject{|s| s >= 100}.minmax).inspect
puts "used range (excl whales/empty): " + Range.new(*nodes.values.map(&:used).reject{|u| u >= 100 || u == 0}.minmax).inspect
puts "empty nodes: #{nodes.values.map(&:used).count(0)}"

# yeah, this is just a sliding puzzle game. exactly a sliding puzzle game.
# let's draw a picture.

board = []
xmax, ymax = nodes.keys.max
(0..ymax).each do |y|
  line = ""
  (0..xmax).each do |x|
    node = nodes[[x,y]]
    line << if x == xmax && y == 0
      'G'
    elsif node.used >= nodes[[0, 0]].size
      '#'
    elsif node.used == 0
      '_'
    else
      '.'
    end
  end
  board << line
end

steps = 0
gap_y = board.find_index { |row| row.include?('_') }
gap_x = board[gap_y].index('_')

try_move = ->(dx, dy) {
  raise "oops" unless board[gap_y][gap_x] == '_'
  if (0...board.size).include?(gap_y + dy) && (0...board[0].size).include?(gap_x + dx) && board[gap_y + dy][gap_x + dx] != '#'
    board[gap_y][gap_x] = board[gap_y + dy][gap_x + dx]
    gap_y += dy
    gap_x += dx
    board[gap_y][gap_x] = '_'
    true
  else
    false
  end
}

begin
  Curses.init_screen
  win = Curses::Window.new(0, 0, 0, 0)
  win.keypad = true

  loop do
    win.setpos(0, 0)
    win << "steps: #{steps}"
    (0..ymax).each do |y|
      win.setpos(y + 2, 0)
      win << board[y]
    end
    Curses.refresh

    moved = case win.getch
    when Curses::Key::LEFT
      try_move.(-1, 0)
    when Curses::Key::RIGHT
      try_move.(1, 0)
    when Curses::Key::UP
      try_move.(0, -1)
    when Curses::Key::DOWN
      try_move.(0, 1)
    end
    steps += 1 if moved
  end
ensure
  Curses.close_screen
end
