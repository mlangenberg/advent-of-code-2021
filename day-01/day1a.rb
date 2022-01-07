increases = 0
previous_measurement = nil
ARGF.each_line do |line|
  measurement = line.to_i
  increases += 1 if previous_measurement && measurement > previous_measurement
  previous_measurement = measurement
end
puts increases
