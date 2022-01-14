def decompressed_size(line)
  sz = 0
  i = 0
  loop do
    if (op = line.index('(', i))
      sz += (op - i)
      cp = line.index(')', op)
      raise "missing )" unless cp
      marker = line[op+1...cp].split('x').map(&:to_i)
      raise "bad marker" unless marker.size == 2
      rep = line[cp+1..cp+marker[0]]
      sz += decompressed_size(rep) * marker[1]
      i = cp + marker[0] + 1
    else
      sz += (line.size - i)
      return sz
    end
  end
end

ARGF.each_line do |line|
  puts decompressed_size(line.strip)
end
