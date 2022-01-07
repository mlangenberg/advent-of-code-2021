require 'matrix'

random_numbers = ARGF.gets.chomp.split(',')

boards = []
rows = []
ARGF.each_line do |line|
  next if line.chomp.empty?

  rows << line.scan(/\d{1,2}/)
  if rows.size == 5
    boards << Matrix.rows(rows)
    rows = []
  end
end

board, number = catch(:bingo) do
  random_numbers.each do |number|
    boards.each do |board|
      board.each_with_index do |e, row, col|
        next unless e == number

        board[row, col] = nil
        [*board.row_vectors, *board.column_vectors].each do |vector|
          throw :bingo, [board, number] if vector.to_a.none?
        end
      end
    end
  end
end

if board
  puts "Bingo on #{number}!"
  sum = 0
  board.each { |e| sum += e.to_i }
  puts "Sum of unmarked numbers: #{sum}"
  puts "Final score: #{sum * number.to_i}"
end
