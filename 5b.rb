require 'digest'
door_id = ARGV.first || "ffykfhsq"
nonce = 0
password = "_" * 8
loop do
  h = Digest::MD5.hexdigest("#{door_id}#{nonce}")
  nonce += 1
  if h.start_with?("00000")
    pos = h[5].to_i(16)
    password[pos] = h[6] if pos < 8 && password[pos] == '_'
    puts password
    break unless password.include?('_')
  end
end
