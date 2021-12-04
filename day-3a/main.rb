numbers = STDIN.readlines.map do |line|
  line.scan(/\d/).map(&:to_i)
end

most_common_treshold = numbers.size / 2
gamma_rate_length = numbers.first.size
gamma_rate_bits = Array.new(gamma_rate_length) do |i|
  sum = numbers.map { |bits| bits[i] }.sum
  sum > most_common_treshold ? 1 : 0
end

gamma_rate = gamma_rate_bits.join.to_i(2)
epsilon_rate = gamma_rate ^ (2 ** gamma_rate_length -1)

puts "Gamma rate: #{gamma_rate}"
puts "Epsilon rate: #{epsilon_rate}"
puts
puts "Product: #{gamma_rate * epsilon_rate}"