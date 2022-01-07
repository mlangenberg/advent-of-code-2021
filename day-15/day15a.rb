require 'matrix'

Point = Struct.new(:row, :column)

class Map < Matrix
  def first = Point[0, 0]
  def last = Point[row_count - 1, column_count - 1]

  def neighbors(point)
    [
      [point.row - 1, point.column], [point.row, point.column - 1],
      [point.row + 1, point.column], [point.row, point.column + 1]
    ]
      .select { |row, col| [row, col].min >= 0 && row < row_count && col < column_count }
      .map { |index| Point[*index] }
  end

  def distance(source, target)
    distances = {}
    queue = []

    each_with_index do |_, row, column|
      distances[Point[row, column]] = Float::INFINITY
      queue << Point[row, column]
    end
    distances[source] = 0

    until queue.empty?
      current, distance = distances.slice(*queue).min_by(&:last)
      queue.delete(current)
      return distance if current == target

      neighbors(current).each do |point|
        next unless queue.include?(point)

        distance_to_neighbor = distance + self[point.column, point.row]
        distances[point] = distance_to_neighbor if distance_to_neighbor < distances[point]
      end
    end
    Float::INFINITY
  end
end

map = Map.rows(ARGF.readlines.map(&:chomp).map { |line| line.chars.map(&:to_i) })
puts map.distance(map.first, map.last)
