require 'matrix'

Point = Struct.new(:row, :column)

class Map < Matrix
  def first
    Point[0, 0]
  end

  def last
    Point[row_count - 1, column_count - 1]
  end

  def neighbors(point)
    indices = [
      [point.row - 1, point.column], [point.row, point.column - 1],
      [point.row + 1, point.column], [point.row, point.column + 1]
    ].select do |other_row, other_column|
      [other_row, other_column].min >= 0 &&
        other_row < row_count &&
        other_column < column_count
    end
    indices.map do |other_row, other_column|
      [Point[other_row, other_column], self[other_row, other_column]]
    end
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

      neighbors(current).each do |point, length|
        next unless queue.include?(point)

        distance_to_neighbor = distance + length
        distances[point] = distance_to_neighbor if distance_to_neighbor < distances[point]
      end
    end
    Float::INFINITY
  end
end


map = Map.rows(ARGF.readlines.map(&:chomp).map { |line| line.chars.map(&:to_i) })

# binding.pry

puts map.distance(map.first, map.last)
