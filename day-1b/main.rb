count = 0
previous_measurement = nil
buffer = []
STDIN.each_line do |line|
  buffer << line.to_i
  if buffer.size == 3
    measurement = buffer.sum
    buffer.shift
    if previous_measurement
      count += 1 if measurement > previous_measurement
    end
    previous_measurement = measurement
  end
end
puts count
