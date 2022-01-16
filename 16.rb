def expand(stuff)
  stuff + "0" + stuff.reverse.tr("01", "10")
end

def checksum(stuff)
  stuff = stuff.chars.each_slice(2).map{ |a, b| a == b ? '1' : '0'}.join while stuff.size.even?
  stuff
end

data = ARGV[0] || "10000"
size = ARGV[1].to_i || 20

data = expand(data) while data.size < size
data = data[0...size]

puts checksum(data)
