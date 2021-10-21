require 'musa-dsl'

require_relative 'keyboard-instrument'

class FEBlanchetHarpsichord < Harpsichord
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('f1')..pitch('d6')
    @polyphony = 3
    super
  end
end
