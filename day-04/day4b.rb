require 'matrix'

random_numbers = STDIN.gets.chomp.split(',')

boards = []
rows = []
STDIN.each_line do |line|
  next if line.chomp.empty?
  rows << line.scan(/\d{1,2}/)
  if rows.size == 5
    boards << Matrix.rows(rows)
    rows = []
  end
end

Bingo = Struct.new(:board, :number)
bingos = []

random_numbers.each do |number|
  boards.dup.each_with_index do |board|
    board.each_with_index do |e, row, col|
      if e == number
        board[row,col] = nil
        [*board.row_vectors, *board.column_vectors].each do |vector|
          if vector.to_a.none?
            bingos << Bingo.new(board, number)
            boards.delete(board)
          end
        end
      end
    end
  end
end

bingo = bingos.last
puts "Bingo on #{bingo.number}!"
sum = 0
bingo.board.each { |e| sum += e.to_i }
puts "Sum of unmarked numbers: #{sum}"
puts "Final score: #{sum * bingo.number.to_i}"
