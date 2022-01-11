def checksum(name)
  counts = name.scan(/[a-z]/).group_by(&:itself).transform_values{ |a| a.size }.to_a
  counts.sort_by { |pair| [-pair[1], pair[0]] }.map(&:first)[0...5].join
end

def shift_char(c, shift)
  if ('a'..'z').include? c
    ('a'.ord + (c.ord - 'a'.ord + shift) % 26).chr
  else
    c
  end
end

def decrypt(name, shift)
  name.chars.map { |c| shift_char(c, shift) }.join
end

sum = 0
ARGF.each_line.map do |line|
  if line =~ /([a-z-]+)(\d+)\[([a-z]+)\]/
    if checksum($1) == $3
      sum += $2.to_i
      if decrypt($1, $2.to_i) == "northpole-object-storage-"
        puts $2
      end
    end
  end
end
puts sum
