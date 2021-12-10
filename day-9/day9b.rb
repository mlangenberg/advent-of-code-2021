require 'matrix'
require 'set'

class Heatmap < Matrix
  def adjacents(row, column)
    [
      [row - 1, column], [row, column - 1],
      [row + 1, column], [row, column + 1]
    ].select do |other_row, other_column|
      [other_row, other_column].min >= 0 &&
        other_row < row_count &&
        other_column < column_count
    end
  end
end

rows = []
ARGF.each_line do |line|
  rows << line.chomp.chars.map(&:to_i)
end
heatmap = Heatmap.rows(rows)

low_points = []
heatmap.each_with_index do |value, row, column|
  next if value == 9
  next if heatmap.adjacents(row, column).map do |adjacent|
    heatmap[*adjacent]
  end.min < value

  low_points << [row, column]
end

basins = {}
low_points.each do |point|
  basins[point] = Set.new
  queue = [point]
  while (row, column = queue.pop)
    heatmap.adjacents(row, column).each do |adjacent|
      next if basins[point].include?(adjacent) || heatmap[*adjacent] == 9

      queue.push(adjacent)
      basins[point] << adjacent
    end
  end
end

puts basins.values.map(&:size).sort[-3..].reduce(:*)
