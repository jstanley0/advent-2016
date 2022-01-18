Inst = Struct.new(:opcode, :x, :y) do
  def to_s
    "#{opcode} #{x} #{y}"
  end
end

class Assembunny
  def initialize(program)
    @program = program
  end

  def rvalue(arg)
    if arg =~ /-?(\d+)/
      arg.to_i
    else
      @regs[arg] ||= 0
    end
  end

  def list(title)
    puts title
    @program.each_with_index do |inst, i|
      puts "#{i} #{inst.to_s}"
    end
    puts "---"
  end

  def run(arg)
    ip = 0
    @regs = {'a' => arg}
    limit = ENV['LIMIT']&.to_i
    output = []
    while (0...@program.size).include?(ip)
      inst = @program[ip]
      print "#{ip} #{inst.to_s} " if ENV['TRACE']
      case inst.opcode
      when 'cpy'
        @regs[inst.y] = rvalue(inst.x)
      when 'inc'
        @regs[inst.x] += 1
      when 'dec'
        @regs[inst.x] -= 1
      when 'jnz'
        ip += rvalue(inst.y) - 1 unless rvalue(inst.x).zero?
      when 'out'
        output << rvalue(inst.x)
        break if output.size == 10
      else
        raise "unknown opcode #{inst.opcode}"
      end
      puts "#{@regs.inspect}" if ENV['TRACE']
      ip += 1
      if limit
        limit -= 1
        break if limit.zero?
      end
    end
    output
  end
end

program = ARGF.each_line.map { |line| Inst.new(*line.split) }
computer = Assembunny.new(program)

goal = [0, 1] * 5
(0..).each do |arg|
  if computer.run(arg) == goal
    puts arg
    break
  end
end
