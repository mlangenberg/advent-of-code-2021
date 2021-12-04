class Reducer
  attr_reader :by_most_common_bit
  def initialize(by_most_common_bit: true)
    @by_most_common_bit = by_most_common_bit
  end

  def reduce(numbers, position = 0)
    return numbers.first if numbers.one?

    most_common_treshold = numbers.size / 2.to_f
    sum = numbers.map { |bits| bits[position] }.sum
    bit_criteria = if sum == most_common_treshold
      1
    else
      sum > most_common_treshold ? 1 : 0
    end
    reduce(
      select_numbers_for_criteria(numbers, position, bit_criteria),
      position + 1
    )
  end

  def select_numbers_for_criteria(numbers, position, bit_criteria)
    unless by_most_common_bit
      bit_criteria = 1 - bit_criteria
    end
    numbers.select { |bits| bits[position] == bit_criteria }
  end
end

numbers = STDIN.readlines.map do |line|
  line.scan(/\d/).map(&:to_i)
end

oxygen_rate, co2_rate = [
  Reducer.new(by_most_common_bit: true),
  Reducer.new(by_most_common_bit: false)
].map { |reducer| reducer.reduce(numbers).join.to_i(2) }

puts "Oxygen generator rating: #{oxygen_rate}"
puts "CO2 scrubber rating: #{co2_rate}"
puts
puts "Product: #{oxygen_rate * co2_rate}"
