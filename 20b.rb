ranges = []

ARGF.each_line do |line|
  range = line.split('-').map(&:to_i)
  ranges.delete_if do |other_range|
    if other_range.first <= range.first && other_range.last >= range.first - 1 ||
       other_range.first >= range.first && other_range.first <= range.last + 1
      range[0] = [range[0], other_range[0]].min
      range[1] = [range[1], other_range[1]].max
      true
    else
      false
    end
  end
  ranges << range
end

ranges.sort!

if ranges[0][0] == 0
  puts ranges[0][1] + 1
end

puts (1 << 32) - ranges.map { |first, last| (last - first) + 1 }.sum

