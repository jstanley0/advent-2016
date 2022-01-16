require 'byebug'

Inst = Struct.new(:opcode, :x, :y)

class Assembunny
  def initialize(program, opts = {})
    @program = program
    @ip = 0
    @regs = {}.merge(opts)
  end

  def rvalue(arg)
    if arg =~ /-?(\d+)/
      arg.to_i
    else
      @regs[arg] ||= 0
    end
  end

  def run
    while (0...@program.size).include?(@ip)
      inst = @program[@ip]
      case inst.opcode
      when 'cpy'
        @regs[inst.y] = rvalue(inst.x)
      when 'inc'
        @regs[inst.x] += 1
      when 'dec'
        @regs[inst.x] -= 1
      when 'jnz'
        @ip += rvalue(inst.y) - 1 unless rvalue(inst.x).zero?
      end
      @ip += 1
    end
    puts @regs.inspect
  end
end


program = ARGF.each_line.map { |line| Inst.new(*line.split) }
Assembunny.new(program, 'c' => 1).run
