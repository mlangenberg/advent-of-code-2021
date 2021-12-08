EASY_DIGITS = /\b(\w{2}|\w{4}|\w{3}|\w{7})\b/
count = 0
STDIN.each_line do |line|
  count += line.split(' | ').last.scan(EASY_DIGITS).count
end
puts count
