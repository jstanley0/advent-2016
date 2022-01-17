Node = Struct.new(:size, :used, :avail, :pct)
nodes = {}

ARGF.each_line.map do |line|
  if line =~ %r{/dev/grid/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)%}
    x, y = [$1, $2].map(&:to_i)
    nodes[[x, y]] = Node.new(*[$3, $4, $5, $6].map(&:to_i))
  end
end

puts nodes.values.combination(2).count { |a, b|
  a.used > 0 && b.avail >= a.used || b.used > 0 && a.avail >= b.used
}
