require 'z3'

t = Z3::Int("t")
opt = Z3::Optimize.new

ARGF.each_line do |line|
  if line =~ /Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)/
    opt.assert((t + ($1.to_i + $3.to_i)).mod($2.to_i) == 0)
  end
end

opt.assert(t >= 0)
opt.minimize(t)

if opt.satisfiable?
  puts opt.model.to_s
else
  puts "no solution :("
end
