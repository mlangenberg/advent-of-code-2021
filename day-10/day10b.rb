TOKENS = {
  '[' => ']', '(' => ')', '{' => '}', '<' => '>'
}
AUTOCOMPLETE_SCORES = {
  ')' => 1, ']' => 2, '}' => 3, '>' => 4
}

scores = []
ARGF.each_line do |line|
  catch(:syntax_error) do
    stack = []
    line.chomp.chars.each do |char|
      if TOKENS.key?(char)
        stack.push(char)
      else
        expected = TOKENS[stack.last]
        if expected != char
          puts "Error on line: #{ARGF.lineno}, unexpected '#{char}', expecting '#{expected}'"
          throw :syntax_error
        end
        stack.pop
      end
    end
    next if stack.empty?

    expected = stack.map { |char| TOKENS[char] }.reverse
    puts "Error on line: #{ARGF.lineno}, unexpected EOL, expecting '#{expected.join(', ')}'"
    scores << expected.map { |c| AUTOCOMPLETE_SCORES[c] }
                      .inject(0) { |total, score| total * 5 + score }
  end
end

puts scores.sort[scores.size / 2]
