positions = STDIN.gets.split(',').map(&:to_i).sort
average = positions.sum(0.0) / positions.size
fuel = [average.floor, average.ceil].map do |target|
  positions
    .map { |position| (target - position).abs }
    .map { |distance| (1..distance).sum }.sum
end.min

puts "Consumed fuel: #{fuel}"
