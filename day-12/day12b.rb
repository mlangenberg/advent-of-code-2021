@connections = Hash.new { |hash, key| hash[key] = [] }
ARGF.each_line do |line|
  from, to = line.chomp.split('-').map(&:to_sym)
  @connections[from] << to
  @connections[to] << from
end

def explore(current, path = [], paths = [], allow_lowercase_node_twice = true)
  paths << path.push(:end) and return if current == :end

  @connections[current].each do |node|
    next if node == :start

    if node =~ /^[[:lower:]]+$/ && path.include?(node)
      next unless allow_lowercase_node_twice

      explore(node, path.dup.push(current), paths, false)
    else
      explore(node, path.dup.push(current), paths, allow_lowercase_node_twice)
    end
  end

  paths
end

puts explore(:start).size
