# Run with: `ruby day6.rb input.txt 80` for 80 iterations
fishes = ARGF.gets.split(',').map(&:to_i)
days = ARGV.shift || 18
counts_by_age = fishes.each_with_object(Hash.new(0)) { |e, h| h[e] += 1 }

days.to_i.times do |day|
  count = counts_by_age.delete(day) || 0
  counts_by_age[day + 7] += count
  counts_by_age[day + 9] += count
end

puts "After #{days} days:"
puts counts_by_age.values.sum
