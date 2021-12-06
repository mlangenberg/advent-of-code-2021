@list = STDIN.gets.split(",").map(&:to_i)

def list_as_string
  "#{@list.count}\t#{$VERBOSE ? @list.join(',') : ''}"
end

def tick
  @list.dup.each_with_index do |value, i|
    if value == 0
      @list[i] = 6
      @list << 8
    else
      @list[i] -= 1
    end
  end
end

puts "Initial state: #{list_as_string}"
80.times do |day|
  tick
  puts "After #{day+1} day(s): #{list_as_string}"
end

