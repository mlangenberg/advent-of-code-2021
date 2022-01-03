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
  dots.map do |dot|
    if dot[along.axis] > along.line
      dot[along.axis] = along.line - (dot[along.axis] - along.line)
    end
    dot
  end
end

def print(dots)
  system('tput clear')
  dots.sort_by(&:y).each do |dot|
    system("tput cup #{dot.y} #{dot.x}")
    putc '#'
  end
  puts
end

while (f = folds.shift)
  dots = fold(dots, f).uniq
end


print(dots)