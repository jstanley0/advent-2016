require 'byebug'

Inst = Struct.new(:opcode, :x, :y) do
  def to_s
    "#{opcode} #{x} #{y}"
  end
end

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

  def list(title)
    puts title
    @program.each_with_index do |inst, i|
      puts "#{i} #{inst.to_s}"
    end
    puts "---"
  end

  def run
    limit = ENV['LIMIT']&.to_i
    while (0...@program.size).include?(@ip)
      inst = @program[@ip]
      print "#{@ip} #{inst.to_s} " if ENV['TRACE']
      debugger if @ip == 11 || @ip == 16
      case inst.opcode
      when 'cpy'
        @regs[inst.y] = rvalue(inst.x)
      when 'inc'
        @regs[inst.x] += 1
      when 'dec'
        @regs[inst.x] -= 1
      when 'jnz'
        @ip += rvalue(inst.y) - 1 unless rvalue(inst.x).zero?
      when 'tgl'
        target = @ip + rvalue(inst.x)
        if target >= 0 && target < @program.size
          case @program[target].opcode
          when 'cpy'
            @program[target].opcode = 'jnz'
          when 'jnz'
            @program[target].opcode = 'cpy'
          when 'inc'
            @program[target].opcode = 'dec'
          when 'dec', 'tgl'
            @program[target].opcode = 'inc'
          else
            raise "plz implement tgl on #{@program[target].opcode}"
          end
        end
      else
        raise "unknown opcode #{inst.opcode}"
      end
      puts "#{@regs.inspect}" if ENV['TRACE']
      @ip += 1
      if limit
        limit -= 1
        break if limit.zero?
      end
    end
    puts @regs.inspect
  end
end

arg = ARGV.delete_at(1)&.to_i || 7

program = ARGF.each_line.map { |line| Inst.new(*line.split) }
Assembunny.new(program, 'a' => arg).run
