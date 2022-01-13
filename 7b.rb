def abas(seg)
  seg.chars.each_cons(3).select { _1 == _3 && _1 != _2 }.map { [_1, _2] }
end

def tls?(addr)
  supernets = []
  hypernets = []
  addr.scan(/(\[)?([a-z]+)\]?/).each do |hn, seg|
    (hn ? hypernets : supernets) << seg
  end
  supernet_abas = supernets.map{ |seg| abas(seg) }.flatten(1)
  hypernet_abas = hypernets.map{ |seg| abas(seg) }.flatten(1).map(&:reverse)
  (supernet_abas & hypernet_abas).any?
end

puts ARGF.each_line.count{ |line| tls?(line) }
