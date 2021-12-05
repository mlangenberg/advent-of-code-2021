require 'matrix'

Point = Struct.new(:x, :y)
Segment = Struct.new(:from, :to) do
  def to_a
    if from.y == to.y
      Range.new(*[from.x, to.x].sort).map do |x|
        Point.new(x, from.y)
      end
    elsif from.x == to.x
      Range.new(*[from.y, to.y].sort).map do |y|
        Point.new(from.x, y)
      end
    end
  end
end

segments = []
STDIN.each_line do |line|
  match = line.match /(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)/
  if match[:x1] == match[:x2] || match[:y1] == match[:y2]
    segments << Segment.new(
      Point.new(match[:x1].to_i, match[:y1].to_i),
      Point.new(match[:x2].to_i, match[:y2].to_i)
    )
  end
end

max_x = segments.map { |s| [s.from.x, s.to.x ] }.flatten.max
max_y = segments.map { |s| [s.from.y, s.to.y ] }.flatten.max

map = Matrix.zero(max_y + 1, max_x + 1)
segments.each do |segment|
  segment.to_a.each do |point|
    map[point.y, point.x] += 1
  end
end

map.row_vectors.each do |row|
  puts row.map { |i| i == 0 ? '.' : i }.to_a.join
end

overlapping_points = 0
map.each do |e|
  overlapping_points += 1 if e > 1
end
puts
puts "Overlapping points: #{overlapping_points}"

