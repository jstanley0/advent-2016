require 'digest'

State = Struct.new(:x, :y, :path) do
  def goal?
    x == 3 && y == 3
  end

  def each_neighbor
    h = Digest::MD5.hexdigest(path)
    yield State.new(x, y - 1, path + 'U') if y > 0 && h[0] > 'a'
    yield State.new(x, y + 1, path + 'D') if y < 3 && h[1] > 'a'
    yield State.new(x - 1, y, path + 'L') if x > 0 && h[2] > 'a'
    yield State.new(x + 1, y, path + 'R') if x < 3 && h[3] > 'a'
  end
end

password = ARGV.first || "hijkl"
states = [State.new(0, 0, password)]
step = 0

until states.empty?
  puts "considering #{states.size} states at step #{step}"
  step += 1

  next_states = []

  states.each do |state|
    if state.goal?
      puts state.path
      next
    end

    state.each_neighbor do |substate|
      next_states << substate
    end
  end

  states = next_states
end
