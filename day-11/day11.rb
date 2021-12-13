# Usage: ruby day11.rb input.txt --steps=100 for part one
#        ruby day11.rb input.txt for part two

require 'matrix'

class Grid < Matrix
  def print
    puts(to_a.map { |row| row.to_a.map(&:peek).join })
    puts
  end

  def zero?
    each { |value| return false unless value.peek.zero? }
    true
  end

  def adjacents(*origin)
    indices = (-1..1).to_a.product((-1..1).to_a).map do |offset|
      [origin, offset].transpose.map { |tuple| tuple.reduce(:+) }
    end - origin
    valid_indices = indices.select do |row, column|
      [row, column].min >= 0 && row < row_count && column < column_count
    end
    valid_indices.map { |row, column| [self[row, column], row, column] }
  end

  def next
    each(&:next)

    zeroed = each_with_index.select { |value, *| value.peek.zero? }

    while (_, row, column = zeroed.pop)
      adjacents(row, column).each do |adjacent|
        next if adjacent[0].peek.zero?

        adjacent[0].next
        zeroed << adjacent if adjacent[0].peek.zero?
      end
    end

    each_with_index.select { |value, *| value.peek.zero? }.count
  end
end

steps = 0
if ARGV.last =~ /--steps=(\d+)/
  ARGV.pop
  steps = Regexp.last_match(1).to_i
end

grid = Grid.rows(
  ARGF.readlines.map do |line|
    line.chomp.chars.map(&:to_i).map { |n| [*n..9, *0...n].cycle }
  end
)

flashes = 0
step = 0
loop do
  step += 1
  flashes += grid.next
  break if grid.zero?
  break if step == steps
end

puts "After step #{step}:"
grid.print

puts "Total flashes: #{flashes}"
