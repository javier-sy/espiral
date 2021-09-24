require_relative 'instrument'

class InstrumentsPool
  def initialize(name, *instruments)
    @name = name
    @instruments = instruments
  end

  attr_reader :name
  
  def find_free
    @instruments.find do |instrument|
      instrument.free_voices.positive?
    end
  end

  private def search_path_index(center, size)
    position = center.round
    sign = position < center ? -1 : 1

    counter = previous_counter = 0
    switch = true
    last_switch_done = false


    size.times.collect do
      (position + sign * counter).tap do |i|
        case i
        when 0
          sign = 1
          switch = false
        when size - 1
          sign = -1
          switch = false
        end

        sign *= -1 if switch

        _previous_counter = counter
        counter += 1 if !switch && last_switch_done || counter == previous_counter
        last_switch_done = !switch
        previous_counter = _previous_counter
      end
    end
  end

  def find_free_with(timbre:, pitch: nil)

    start_position = (@instruments.size - 1) * timbre

    path = search_path_index(start_position, @instruments.size)

    found_index = path.find do |i|
      @instruments[i].free_voices.positive? && @instruments[i].pitch_range.include?(pitch)
    end

    @instruments[found_index] if found_index
  end

  def to_s
    "Instrument pool #{@name}: #{@instruments.size} instruments, #{@instruments.collect(&:free_voices).sum} free voices"
  end
end