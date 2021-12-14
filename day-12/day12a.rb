@connections = Hash.new { |hash, key| hash[key] = [] }
ARGF.each_line do |line|
  from, to = line.chomp.split('-').map(&:to_sym)
  @connections[from] << to
  @connections[to] << from
end

def explore(current, path = [], paths = [])
  paths << path.push(:end) and return if current == :end

  @connections[current].each do |node|
    next if node =~ /^[[:lower:]]+$/ && path.include?(node)

    explore(node, path.dup.push(current), paths)
  end

  paths
end

puts explore(:start).size
