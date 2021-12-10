require 'matrix'

rows = []
ARGF.each_line do |line|
  rows << line.chomp.chars.map(&:to_i)
end
heatmap = Matrix.rows(rows)
risk_factor = 0
heatmap.each_with_index do |point, row, column|
  next if point == 9

  adjacent_locations = [
    [row - 1, column], [row, column - 1],
    [row + 1, column], [row, column + 1]
  ].select do |other_row, other_column|
    [other_row, other_column].min >= 0 &&
      other_row < heatmap.row_count &&
      other_column < heatmap.column_count
  end
  next if adjacent_locations.map do |other_row, other_column|
    heatmap[other_row, other_column]
  end.min < point

  risk_factor += 1 + point
end

puts risk_factor
