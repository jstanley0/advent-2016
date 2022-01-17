if ARGV.size < 2
  puts "usage: ruby 21.rb instruction_file start_string"
  exit 1
end

letters = ARGV[1].chars
File.read(ARGV[0]).each_line do |line|
  if line =~ /swap position (\d+) with position (\d+)/
    p1, p2 = $1.to_i, $2.to_i
    letters[p1], letters[p2] = letters[p2], letters[p1]
  elsif line =~ /swap letter (\w) with letter (\w)/
    letters.map! { |letter| letter.tr("#$1#$2", "#$2#$1") }
  elsif line =~ /rotate (left|right) (\d+) steps?/
    letters.rotate!(($1 == "right" ? -1 : 1) * $2.to_i)
  elsif line =~ /rotate based on position of letter (\w)/
    r = letters.index($1)
    r += (r >= 4) ? 2 : 1
    letters.rotate!(-r)
  elsif line =~ /reverse positions (\d+) through (\d+)/
    p1, p2 = $1.to_i, $2.to_i
    letters = letters[0...p1] + letters[p1..p2].reverse + letters[p2+1..]
  elsif line =~ /move position (\d+) to position (\d+)/
    letter = letters.delete_at($1.to_i)
    letters.insert($2.to_i, letter)
  end
  puts "#{line.strip} => #{letters.join}"
end
