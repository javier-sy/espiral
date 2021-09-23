require_relative 'instrument'

class InstrumentsPool
  def initialize(*instruments)
    @instruments = instruments
  end

  def find_free
    @instruments.find do |instrument|
      instrument.free_voices.positive?
    end
  end

  def find_free_with(timbre:, pitch: nil)

    center_position = (@instruments.size * timbre).round

    i = -1
    min_position = @instruments.size - 1
    max_position = 0

    begin
      i += 1
      position = center_position + (i / 2) * ((i % 2).zero? ? 1 : -1)
      min_position = position if position < min_position
      max_position = position if position > max_position

    end until (@instruments[position]&.free_voices&.positive? &&
               @instruments[position]&.pitch_range&.include?(pitch)) ||
      min_position.negative? && max_position > @instruments.size

    if @instruments[position]&.free_voices.nil?
      error "@instruments[#{position}]&.free_voices.nil?"
    end

    @instruments[position] if @instruments[position]&.free_voices&.positive?
  end
end