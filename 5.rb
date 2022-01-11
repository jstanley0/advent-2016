require 'digest'
door_id = ARGV.first || "ffykfhsq"
nonce = 0
8.times do
  loop do
    h = Digest::MD5.hexdigest("#{door_id}#{nonce}")
    nonce += 1
    if h.start_with?("00000")
      print h[5]
      break
    end
  end
end
puts
