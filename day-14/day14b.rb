template = ARGF.gets.chomp
polymer = template.chars.each_cons(2).to_a.tally

ARGF.gets # skip line

rules = {}
ARGF.each_line do |line|
  match = line.match(/(\D+) -> (\D)/)
  rules[match[1].chars] = match[2]
end

def grow(polymer, rules)
  polymer.each_with_object(Hash.new(0)) do |(pair, count), next_polymer|
    inserted_element = rules[pair]
    next_polymer[[pair.first, inserted_element]] += count
    next_polymer[[inserted_element, pair.last]] += count
  end
end

def counts(polymer, template)
  polymer
    .each_with_object(Hash.new(0)) { |(pair, count), totals| totals[pair.first] += count }
    .tap { |totals| totals[template[-1]] += 1 }
end

puts "Template: #{template}"
40.times do |i|
  polymer = grow(polymer, rules)
  puts "After step #{i + 1}: #{counts(polymer, template)}"
end

puts "Answer: #{counts(polymer, template).values.minmax.reverse.reduce(:-)}"
