Packet = Struct.new(:version, :type_id, :value,
                    :length_type_id, :packets_length, :packets,
                    keyword_init: true) do
  self::OPERATIONS = {
    0 => :+,
    1 => :*,
    2 => ->(a, b) { a < b ? a : b },
    3 => ->(a, b) { a > b ? a : b },
    5 => ->(a, b) { a > b ? 1 : 0 },
    6 => ->(a, b) { a < b ? 1 : 0 },
    7 => ->(a, b) { a == b ? 1 : 0 }
  }.freeze

  def self.decode(input)
    packet = new(
      version: input.shift(3).join.to_i(2),
      type_id: input.shift(3).join.to_i(2),
      packets: []
    )
    if packet.literal?
      value_bits = []
      value_bits.concat(input.shift(5)[1..]) until input.first.zero?
      value_bits.concat(input.shift(5)[1..])
      packet.value = value_bits.join.to_i(2)
    else
      packet.length_type_id = input.shift
      packet.packets_length = input.shift(packet.length_bits).join.to_i(2)
      packet.packets =
        if packet.length_type_id.zero?
          decode_packets(input.shift(packet.packets_length))
        else
          decode_packets(input, max: packet.packets_length)
        end
    end
    packet
  end

  def self.decode_packets(input, max: nil)
    [].tap { |packets| packets << decode(input) until input.empty? || packets.size == max }
  end

  def literal? = type_id == 4
  def length_bits = length_type_id.zero? ? 15 : 11

  def value
    literal? ? self[:value] : packets.map(&:value).reduce(&Packet::OPERATIONS[type_id])
  end
end

input = ARGF.read.chomp.chars.map { |c| format('%04d', c.to_i(16).to_s(2)) }.join.chars.map(&:to_i)
packet = Packet.decode(input)
sum = ->(f, packet) { packet.version + packet.packets.map { |p| sum.(f, p) }.sum }
puts "Sum of all packet versions: #{sum.(sum, packet)}"
puts "Packet value: #{packet.value}"
