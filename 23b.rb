def stupid(a)
  b = a - 1
  while b > 1
    a *= b
    b -= 1
  end
  a + 81 * 92
end

puts stupid(ARGV[0]&.to_i || 7)

=begin
cpy a b
dec b
cpy a d
cpy 0 a
cpy b c
inc a
dec c
jnz c -2
dec d
jnz d -5
dec b
cpy b c
cpy c d
dec d
inc c
jnz d -2
tgl c
cpy -16 c
jnz 1 c *
cpy 81 c
jnz 92 d *
inc a
inc d *
jnz d -2
inc c *
jnz c -5
=end
