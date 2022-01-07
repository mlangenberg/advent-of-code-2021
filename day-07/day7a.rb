positions = ARGF.gets.split(',').map(&:to_i).sort

middle = positions.length / 2
median = positions[middle - 1, 2].sum / 2

puts "The median is: #{median}"
distance = positions.map { |pos| median - pos }.map(&:abs).sum
puts "Consumed fuel: #{distance}"
