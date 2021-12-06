fishes = STDIN.gets.split(",").map(&:to_i)
counts_by_age = fishes.each_with_object(Hash.new(0)) { |e,h| h[e] += 1 }

256.times do |day|
  counts_by_age.dup.each do |age, count|
    if age == day
      counts_by_age[day + 7] += counts_by_age.delete(age)
      counts_by_age[day + 9] += count
    end
  end
end

puts counts_by_age.values.sum
