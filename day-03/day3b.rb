class Reducer
  attr_reader :numbers, :position, :by_most_common_bit

  def initialize(numbers, position = 0, by_most_common_bit: true)
    @numbers = numbers
    @position = position
    @by_most_common_bit = by_most_common_bit
  end

  def reduce
    return numbers.first.join.to_i(2) if numbers.one?

    Reducer.new(
      select_by_criteria(most_common_bit),
      position + 1,
      by_most_common_bit:
    ).reduce
  end

  def most_common_bit
    most_common_treshold = numbers.size / 2.to_f
    sum = numbers.map { |bits| bits[position] }.sum
    if sum == most_common_treshold
      1
    else
      sum > most_common_treshold ? 1 : 0
    end
  end

  def select_by_criteria(bit_criteria)
    bit_criteria = 1 - bit_criteria unless by_most_common_bit
    numbers.select { |bits| bits[position] == bit_criteria }
  end
end

numbers = ARGF.readlines.map do |line|
  line.scan(/\d/).map(&:to_i)
end

oxygen_rate, co2_rate = [
  Reducer.new(numbers, by_most_common_bit: true),
  Reducer.new(numbers, by_most_common_bit: false)
].map(&:reduce)

puts "Oxygen generator rating: #{oxygen_rate}"
puts "CO2 scrubber rating: #{co2_rate}"
puts
puts "Product: #{oxygen_rate * co2_rate}"
