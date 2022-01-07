count = 0
previous_measurement = nil
buffer = []
ARGF.each_line do |line|
  buffer << line.to_i
  next unless buffer.size == 3

  measurement = buffer.sum
  buffer.shift
  count += 1 if previous_measurement && measurement > previous_measurement
  previous_measurement = measurement
end
puts count
