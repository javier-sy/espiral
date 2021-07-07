require 'musa-dsl'

require_relative 'keyboard-instrument-pianoteq'

class FEBlanchetHarpsichord < Harpsichord_Pianoteq
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch("f1")..pitch("d6")
    @polyphony = 3

    super
  end
end
