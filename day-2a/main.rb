position = Struct.new(:depth, :distance).new(0,0)

STDIN.each_line do |line|
  command, units = line.split
  case command
  when 'forward'
    position.distance += units.to_i
  when 'down'
    position.depth += units.to_i
  when 'up'
    position.depth -= units.to_i
  end
end

puts "horizontal position: #{position.distance}"
puts "depth: #{position.depth}"
puts
puts "product: #{position.distance * position.depth}"