# Run with: `ruby day20.rb input.txt 50` for 50 iterations
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

image = input.each_with_index.each_with_object(Hash.new(0)) do |(pixels, row), hash|
  pixels.each_with_index { |pixel, column| hash[[row, column]] = pixel }
end

def enhanced_pixel(image, row, column)
  indices = (-1..1).to_a.product((-1..1).to_a).map do |offset|
    [[row, column], offset].transpose.map { |tuple| tuple.reduce(:+) }
  end
  ALGORITHM[indices.map { |index| image[index] }.join.to_i(2)]
end

def enhance(image)
  output = Hash.new(ALGORITHM[0].nonzero? && image.default.zero? ? 1 : 0)
  range = image.keys.min.min - 2..image.keys.max.max + 2
  range.to_a.repeated_permutation(2).each do |row, column|
    output[[row, column]] = enhanced_pixel(image, row, column)
  end
  output
end

def print(image)
  prev_row = nil
  image.sort.to_h.each do |(row, _), pixel|
    putc "\n" and prev_row = row unless prev_row == row
    putc(pixel.zero? ? '.' : '#')
  end
  puts
end

print(image) if $VERBOSE
STEPS.times do
  image = enhance(image)
  print(image) if $VERBOSE
end
puts "Lit pixels: #{image.values.reduce(:+)}"
