require_relative 'instrument'

class InstrumentsPool
  def initialize(*instruments)
    @instruments = instruments
  end

  def find_free
    @instruments.find do |instrument|
      instrument.free_voices > 0
    end
  end
end