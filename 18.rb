if ARGV.size < 1
  puts "usage: ruby 18.rb top_row [num_rows]"
  exit 1
end

top_row = ARGV[0]
if top_row.include? '^'
  top_row = top_row.strip
else
  top_row = File.read(top_row).strip
end

num_rows = ARGV[1]&.to_i || top_row.size

map = [top_row]
(num_rows - 1).times do |i|
  next_row = []
  top_row.size.times do |j|
    prev = [(j > 0) ? map[i][j - 1] : '.', map[i][j], (j < top_row.size - 1) ? map[i][j + 1] : '.'].join
    next_row << (%w[^^. .^^ ^.. ..^].include?(prev) ? '^' : '.')
  end
  map << next_row.join
end

puts map
puts map.map { |row| row.count('.') }.sum
