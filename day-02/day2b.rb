position = Struct.new(:depth, :distance, :aim).new(0, 0, 0)

ARGF.each_line do |line|
  command, units = line.split
  case command
  when 'forward'
    position.distance += units.to_i
    position.depth += position.aim * units.to_i
  when 'down'
    position.aim += units.to_i
  when 'up'
    position.aim -= units.to_i
  end
end

puts "horizontal position: #{position.distance}"
puts "depth: #{position.depth}"
puts
puts "product: #{position.distance * position.depth}"
