Rect = Struct.new(:left, :right, :bottom, :top) do
  def contains?(point)
    point.x.between?(left, right) && point.y.between?(bottom, top)
  end

  def behind?(point) = point.x > right || point.y < bottom
end

Point = Struct.new(:x, :y)

class Probe
  attr_reader :position, :vx, :vy, :max_height

  def initialize(vx:, vy:)
    @vx = vx
    @vy = vy
    @position = Point[0, 0]
    @max_height = 0
  end

  def move
    position.x += vx
    position.y += vy
    @max_height = [max_height, position.y].max
    @vx -= 1 unless @vx.zero?
    @vy -= 1
  end
end

target = Rect[*ARGF.read.scan(/-?\d+/).map(&:to_i)]
probes = []
(0..target.right + 1).each do |vx|
  (target.bottom..target.bottom.abs + 1).each do |vy|
    probe = Probe.new(vx:, vy:)
    probe.move until target.contains?(probe.position) || target.behind?(probe.position)
    probes << probe if target.contains?(probe.position)
  end
end

puts "Max height: #{probes.map(&:max_height).max}"
puts "probes: #{probes.count}"
