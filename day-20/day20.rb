# Run with: `ruby day20.rb input.txt 50` for 50 iterations

require 'forwardable'

PIXELS = {
  '.' => 0,
  '#' => 1
}.freeze

file = ARGF.file
STEPS = (ARGV.shift || 2).to_i
ALGORITHM = file.gets.chomp.gsub(/./, PIXELS).chars.map(&:to_i)

file.gets # skip line

input = file.readlines.map(&:chomp).map { |line| line.gsub(/./, PIXELS).chars.map(&:to_i) }
file.close

class Image
  extend Forwardable
  def_delegators :@pixels, :keys, :values, :[], :[]=, :default, :sort
  def initialize(default: 0) = @pixels = Hash.new(default)

  def enhance
    output = Image.new(default: ALGORITHM[0].nonzero? && default.zero? ? 1 : 0)
    range = keys.min.min - 1..keys.max.max + 1
    range.to_a.repeated_permutation(2).each do |row, column|
      output[[row, column]] = enhanced_pixel(row:, column:)
    end
    output
  end

  def enhanced_pixel(row:, column:)
    indices = (-1..1).to_a.product((-1..1).to_a).map do |offset|
      [[row, column], offset].transpose.map { |tuple| tuple.reduce(:+) }
    end
    ALGORITHM[indices.map { |index| self[index] }.join.to_i(2)]
  end

  def count_lit_pixels = values.reduce(:+)

  def print
    prev_row = nil
    sort.to_h.each do |(row, _), pixel|
      putc "\n" and prev_row = row unless prev_row == row
      putc(pixel.zero? ? '.' : '#')
    end
    puts
  end
end

image = Image.new(default: 0)
input.each_with_index do |pixels, row|
  pixels.each_with_index { |value, column| image[[row, column]] = value }
end

image.print if $VERBOSE
STEPS.times do
  image = image.enhance
  image.print if $VERBOSE
end
puts "Lit pixels: #{image.count_lit_pixels}"
