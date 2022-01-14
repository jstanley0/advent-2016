inv = {}
rule = {}
out = {}

ARGF.each_line do |line|
  if line =~ /value (\d+) goes to bot (\d+)/
    (inv[$2.to_i] ||= []) << $1.to_i
  elsif line =~ /bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/
    raise "dup rule" if rule.key?($1.to_i)
    rule[$1.to_i] = { low: [$2.to_sym, $3.to_i], high: [$4.to_sym, $5.to_i] }
  end
end

xfer = ->(val, rule) {
  case rule.first
  when :bot
    (inv[rule.last] ||= []) << val
  when :output
    (out[rule.last] ||= []) << val
  end
}

loop do
  done = true
  inv.each do |bot, values|
    if values.size > 1
      done = false
      values.sort!
      puts bot if values.first == 17 && values.last == 61
      xfer.(values.shift, rule[bot][:low])
      xfer.(values.pop, rule[bot][:high])
    end
  end
  break if done
end

puts out.inspect
puts out[0].first * out[1].first * out[2].first
