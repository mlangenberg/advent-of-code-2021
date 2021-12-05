require 'matrix'

Point = Struct.new(:x, :y) do
  def to_s; "|#{x}.#{y}"; end
end
Segment = Struct.new(:from, :to) do
  def to_s
    "#{from.x},#{from.y} → #{to.x},#{to.y}"
  end

  def to_a
    if from.y == to.y
      (from.x..to.x).map do |x|
        Point.new(x, from.y)
      end
    elsif from.x == to.x
      (from.y..to.y).map do |y|
        Point.new(from.x, y)
      end
    else
      (from.x..to.x).map.with_index do |x, i|
        if to.y < from.y
          Point.new(x, from.y - i)
        else
          Point.new(x, from.y + i)
        end
      end
    end
  end
end

segments = []
STDIN.each_line do |line|
  match = line.match(/(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)/)
  if match
    segments << Segment.new(*[
      Point.new(match[:x1].to_i, match[:y1].to_i),
      Point.new(match[:x2].to_i, match[:y2].to_i)
    ].sort_by { |point| [point.x, point.y] })
  end
end

if $VERBOSE
  segments.each do |segment|
    puts segment.to_s + " " + segment.to_a.join(&:to_s)
  end
  puts
end

max_x = segments.map { |s| [s.from.x, s.to.x ] }.flatten.max
max_y = segments.map { |s| [s.from.y, s.to.y ] }.flatten.max

map = Matrix.zero(max_y + 1, max_x + 1)
segments.each do |segment|
  segment.to_a.each do |point|
    map[point.y, point.x] += 1
  end
end

if $VERBOSE
  map.row_vectors.each do |row|
    puts row.map { |i| i == 0 ? '.' : i }.to_a.join
  end
end

overlapping_points = 0
map.each do |e|
  overlapping_points += 1 if e > 1
end
puts
puts "Overlapping points: #{overlapping_points}"

