require 'z3'

x = Z3::Int("x")
opt = Z3::Optimize.new
opt.assert(x >= 0)

ARGF.each_line do |line|
  range = line.split('-').map(&:to_i)
  opt.assert(!((x >= range[0]) & (x <= range[1])))
end

opt.minimize(x)

if opt.satisfiable?
  puts opt.model.to_s
else
  puts "no solution :("
end
