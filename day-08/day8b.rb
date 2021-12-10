def Patterns(patterns)
  Patterns.new(patterns.map(&:chars).map(&:sort))
end

class Patterns
  include Enumerable

  def initialize(list)
    @list = list
  end

  def each(&block)
    @list.each(&block)
  end

  def by_count(count)
    Patterns.new(select { |pattern| pattern.size == count })
  end

  def containing(pattern, except: 0)
    select { |other| (pattern-other).size == except }
  end
end

def deduce(segments)
  mapping = {}
  mapping[4] = segments.by_count(4).first
  mapping[9] = segments.by_count(6).containing(mapping[4]).first
  mapping[2] = segments.by_count(5).containing(mapping[9], except: 2).first
  mapping[5] = segments.by_count(5).containing(mapping[2], except: 2).first
  mapping[0] = segments.by_count(6).containing(mapping[5], except: 1).first
  mapping[7] = segments.by_count(3).first
  mapping[3] = segments.by_count(5).containing(mapping[7]).first
  mapping[6] = segments.by_count(6).containing(mapping[7], except: 1).first
  mapping[8] = segments.by_count(7).first
  mapping[1] = segments.by_count(2).first
  mapping.invert
end

sum = 0
STDIN.each_line do |line|
  patterns, output = line.split(' | ').map(&:split)
  mapping = deduce(Patterns(patterns))
  sum += Patterns(output).map { |pattern| mapping[pattern] }.join.to_i
end
puts "Sum of output values #{sum}"