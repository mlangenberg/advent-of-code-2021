require 'matrix'
require 'pairing_heap'

Point = Struct.new(:row, :column)

class Map < Matrix
  def first
    Point[0, 0]
  end

  def last
    Point[row_count - 1, column_count - 1]
  end

  def neighbors(point)
    [
      [point.row - 1, point.column], [point.row, point.column - 1],
      [point.row + 1, point.column], [point.row, point.column + 1]
    ]
      .select { |row, col| [row, col].min >= 0 && row < row_count && col < column_count }
      .map { |index| Point[*index] }
  end

  def distance(source, target)
    distances = Hash.new(Float::INFINITY)
    distances[source] = 0

    queue = PairingHeap::MinPriorityQueue.new

    each_with_index do |_, row, column|
      queue.push(Point[row, column], distances[Point[row, column]])
    end

    until queue.empty?
      current = queue.pop
      return distances[current] if current == target

      neighbors(current).each do |point|
        distance_to_neighbor = distances[current] + self[point.column, point.row]
        if distance_to_neighbor < distances[point]
          distances[point] = distance_to_neighbor
          queue.decrease_key(point, distance_to_neighbor)
        end
      end
    end
    Float::INFINITY
  end
end

tile = Matrix.rows(ARGF.readlines.map(&:chomp).map { |line| line.chars.map(&:to_i) })
map = Map.build(tile.row_count * 5, tile.column_count * 5) do |row, col|
  i = tile[row % tile.row_count, col % tile.column_count] +
      row / tile.row_count +
      col / tile.column_count
  (i - 1) % 9 + 1
end

puts map.distance(map.first, map.last)
