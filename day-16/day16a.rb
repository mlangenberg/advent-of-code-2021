Packet = Struct.new(:version, :type_id, :value,
                    :length_type_id, :packets_length, :packets,
                    keyword_init: true) do
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
      length_bits = packet.length_type_id.zero? ? 15 : 11
      packet.packets_length = input.shift(length_bits).join.to_i(2)
      packet.packets = packet.decode(input)
    end
    packet
  end

  def decode(input)
    length_type_id.zero? ? decode_max_length(input) : decode_max_packets(input)
  end

  def decode_max_length(input)
    bits = input.shift(packets_length)
    packets = []
    packets << Packet.decode(bits) until bits.empty?
    packets
  end

  def decode_max_packets(input)
    packets = []
    packets << Packet.decode(input) until packets.size == packets_length
    packets
  end

  def literal?
    type_id == 4
  end
end

input = ARGF.read.chomp.chars.map { |c| format('%04d', c.to_i(16).to_s(2)) }.join.chars.map(&:to_i)
packet = Packet.decode(input)
sum = ->(f, packet) { packet.version + packet.packets.map { |p| sum.(f, p) }.sum }
puts sum.(sum, packet)
