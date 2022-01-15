require 'pqueue'
require 'byebug'

$element_ids = {}
$n_elements = 0

def element_bit(element)
  id = $element_ids[element]
  unless id
    id = $n_elements
    $n_elements += 1
    $element_ids[element] = id
  end
  1 << id
end

def valid_floor?(chips, gens)
  gens == 0 || (0...$n_elements).all? { |id| chips[id] == 0 || gens[id] != 0 }
end

GameState = Struct.new(:el, :chips, :gens) do
  def valid?
    (0...chips.size).all? { |floor| valid_floor?(chips[floor], gens[floor]) }
  end

  # to prune equivalent states, since all element pairs are interchangeable
  def collapse
    coords = $n_elements.times.map{[0, 0]}
    chips.each_with_index do |cm, floor|
      (0...$n_elements).each do |bit|
        coords[bit][0] = floor if cm[bit] != 0
      end
    end
    gens.each_with_index do |gm, floor|
      (0...$n_elements).each do |bit|
        coords[bit][1] = floor if gm[bit] != 0
      end
    end
    el.to_s + coords.sort.flatten.join
  end

  def dup
    ss = GameState.new
    ss.el = el
    ss.chips = chips.dup
    ss.gens = gens.dup
    ss
  end

  def estimate
    floor_cost = 1
    total = 0
    (chips.size - 2).downto(0).each do |floor|
      (0...$n_elements).each do |id|
        total += floor_cost if chips[floor][id] != 0
        total += floor_cost if gens[floor][id] != 0
      end
      floor_cost += 1
    end
    total / 2
  end

  def move(cm, gm, to_floor)
    ss = dup
    ss.chips[el] ^= cm
    ss.gens[el] ^= gm
    ss.chips[to_floor] ^= cm
    ss.gens[to_floor] ^= gm
    ss.el = to_floor
    ss
  end

  def test_move(cm, gm, to_floor)
    raise "cm invalid" unless (chips[el] & cm == cm) && (chips[to_floor] & cm == 0)
    raise "gm invalid" unless (gens[el] & gm == gm) && (gens[to_floor] & gm == 0)
    if valid_floor?(chips[el] ^ cm, gens[el] ^ gm) && valid_floor?(chips[to_floor] ^ cm, gens[to_floor] ^ gm)
      yield move(cm, gm, to_floor)
      return true
    end
    false
  end

  def enum_moves_to(to_floor, &block)
    raise "to_floor invalid" unless (to_floor - el).abs == 1
    (0...$n_elements).each do |id|
      bit = 1 << id
      if chips[el] & bit != 0
        # for each chip,
        # 1. see if I can move it (alone) to the adjacent floor
        if test_move(bit, 0, to_floor, &block)
          # 2. see if I can move it along with a smaller chip to the adjacent floor
          # (if I can't move it, then I can't move a friend)
          (0...id).each do |other_id|
            if chips[el][other_id] != 0
              bits = bit | (1 << other_id)
              test_move(bits, 0, to_floor, &block)
            end
          end
        end
        # 3. see if I can move it with its generator to the adjacent floor
        # (it's not possible to move it with a _different_ generator because that generator
        # would fry it on the new floor, unless its generator is already on the new floor,
        # in which case the other generator has already fried it. QED)
        if gens[el] & bit != 0
          test_move(bit, bit, to_floor, &block)
        end
      end

      if gens[el] & bit != 0
        # for each generator,
        # 4. see if I can move it (alone) to the adjacent floor
        test_move(0, bit, to_floor, &block)
        # 5. see if I can move it along with a smaller generator to the adjacent floor
        # (this may actually be possible even if I can't move it by itself)
        (0...id).each do |other_id|
          if gens[el][other_id] != 0
            bits = bit | (1 << other_id)
            test_move(0, bits, to_floor, &block)
          end
        end
        # (chip+generator combo was covered above)
      end
    end
  end

  # yields a GameState for each child state
  def enum_moves(&block)
    if el > 0
      enum_moves_to(el - 1, &block)
    end
    if el < chips.size - 1
      enum_moves_to(el + 1, &block)
    end
  end

  def print
    (chips.size - 1).downto(0).each do |floor|
      Kernel.print "#{floor}:#{el == floor ? '*' : ' '}"
      (0...$n_elements).each do |id|
        Kernel.print ('a'.ord + id).chr if chips[floor][id] != 0
        Kernel.print ('A'.ord + id).chr if gens[floor][id] != 0
      end
      puts
    end
    puts "---"
  end
end

chips = []
gens = []
ARGF.each_line do |line|
  chips << line.scan(/([a-z]+)-compatible microchip/).map { |(microchip)| element_bit(microchip) }.inject(0) { _1 | _2 }
  gens << line.scan(/([a-z]+) generator/).map { |(generator)| element_bit(generator) }.inject(0) { _1 | _2 }
end
initial_state = GameState.new(0, chips, gens)

puts $element_ids

QueueEntry = Struct.new(:game_state, :est_total) do
  def <=>(rhs)
    rhs.est_total <=> est_total
  end
end

end_state = "3" * ($n_elements * 2 + 1)

best_dist_to = {initial_state.collapse => 0}

fringe = PQueue.new
fringe.push QueueEntry.new(initial_state, initial_state.estimate)

def build_path(path_links, target_point)
  path = [target_point]
  while (target_point = path_links[target_point])
    path.unshift target_point
  end
  path
end

path_links = {}

until fringe.empty?
  current = fringe.pop

  cs = current.game_state.collapse
  dist_so_far = best_dist_to[cs]
  if cs == end_state
    puts dist_so_far
    build_path(path_links, current.game_state).each_with_index do |state, i|
      puts "step #{i}:"
      state.print
    end
    break
  end

  dist_so_far += 1
  current.game_state.enum_moves do |substate|
    c = substate.collapse
    if best_dist_to[c].nil? || dist_so_far < best_dist_to[c]
      best_dist_to[c] = dist_so_far
      path_links[substate] = current.game_state
      fringe.push QueueEntry.new(substate, dist_so_far + substate.estimate)
    end
  end
end

