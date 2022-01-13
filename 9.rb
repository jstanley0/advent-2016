def decompress(line)
  output = ""
  i = 0
  loop do
    if (op = line.index('(', i))
      output << line[i...op]
      cp = line.index(')', op)
      raise "missing )" unless cp
      marker = line[op+1...cp].split('x').map(&:to_i)
      raise "bad marker" unless marker.size == 2
      rep = line[cp+1..cp+marker[0]]
      output << rep * marker[1]
      i = cp + marker[0] + 1
    else
      output << line[i..]
      return output
    end
  end
end

ARGF.each_line do |line|
  d = decompress(line.strip)
  puts "#{d} : #{d.size}"
end
