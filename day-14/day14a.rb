polymer = ARGF.gets.chomp.chars
ARGF.gets # skip line

rules = {}
ARGF.each_line do |line|
  match = line.match(/(\D+) -> (\D)/)
  rules[match[1]] = match[2]
end

def grow(polymer, rules)
  arr = []
  polymer.each_cons(2) do |first, second|
    arr << first
    arr << rules[[first, second].join]
  end
  arr << polymer.last
  arr
end

puts "Template: #{polymer.join}"
10.times do |i|
  polymer = grow(polymer, rules)
  puts "After step #{i + 1}: #{polymer.count} elements"
end

puts polymer.tally.values.minmax.reverse.reduce(:-)
