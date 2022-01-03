Dot = Struct.new(:x, :y)
Fold = Struct.new(:axis, :line)

dots = []
folds = []

loop do
  line = ARGF.gets.chomp
  break if line.empty?

  dots << Dot.new(*line.split(',').map(&:to_i))
end

ARGF.each_line do |line|
  match = line.match(/([xy])=(\d+)/)
  folds << Fold.new(match[1].to_sym, match[2].to_i)
end

def fold(dots, along)
  dots.each do |dot|
    if dot[along.axis] > along.line
      dot[along.axis] = along.line - (dot[along.axis] - along.line)
    end
  end.uniq!
end

fold(dots, folds.shift)
puts dots.count
