def valid?(tri)
  tri[0] + tri[1] > tri[2] && tri[0] + tri[2] > tri[1] && tri[1] + tri[2] > tri[0]
end

valid = 0
data = ARGF.each_line.map { |line| line.split.map(&:to_i) }
data.each_slice(3) do |rows|
  (0...3).each do |i|
    valid += 1 if valid?([rows[0][i], rows[1][i], rows[2][i]])
  end
end

puts valid


