require 'digest'

KeyCandidate = Struct.new(:pattern, :hash, :index, :ci)

def find_keys(salt)
  key_candidates = []
  keys = []

  (0..).each do |i|
    key_candidates.delete_if { |can| i > can.index + 1000 }

    hash = Digest::MD5.hexdigest(salt + i.to_s)
    2016.times { hash = Digest::MD5.hexdigest(hash) }
    while ki = key_candidates.index { |can| hash.include?(can.pattern) }
      keys << key_candidates[ki].tap { |kc| kc.ci = i }
      puts keys.size
      key_candidates.delete_at(ki)
    end

    if keys.size < 64
      key_candidates << KeyCandidate.new($1 * 5, hash, i) if hash =~ /(.)\1\1/
    elsif key_candidates.empty?
      break
    end
  end

  return keys.sort_by(&:index)[0...64]
end

puts find_keys(ARGV.first&.strip || 'abc')
