increases = 0
previous_measurement = nil
STDIN.each_line do |line|
	measurement = line.to_i
  if previous_measurement
    increases += 1 if measurement > previous_measurement
  end
  previous_measurement = measurement
end
puts increases