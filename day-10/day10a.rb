TOKENS = {
  '[' => ']', '(' => ')', '{' => '}', '<' => '>'
}
SYNTAX_ERROR_SCORES = {
  ')' => 3, ']' => 57, '}' => 1197, '>' => 25137
}

syntax_error_score = 0
ARGF.each_line do |line|
  stack = []
  line.chomp.chars.each do |char|
    if TOKENS.key?(char)
      stack.push(char)
    else
      expected = TOKENS[stack.last]
      if expected != char
        puts "Error on line: #{ARGF.lineno}, unexpected '#{char}', expecting '#{expected}'"
        syntax_error_score += SYNTAX_ERROR_SCORES[char]
        break
      end
      stack.pop
    end
  end
end

puts "Error score: #{syntax_error_score}"
