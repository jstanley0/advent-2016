def abba?(seg)
  seg.scan(/([a-z])([a-z])\2\1/).any? { |a, b| a != b }
end

def tls?(addr)
  segs = []
  addr.scan(/(\[)?([a-z]+)\]?/).each do |hn, seg|
    if hn
      return false if abba?(seg)
    else
      segs << seg
    end
  end
  segs.any? { |seg| abba?(seg) }
end

puts ARGF.each_line.count{ |line| tls?(line) }
