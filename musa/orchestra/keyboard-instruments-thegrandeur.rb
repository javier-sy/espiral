require 'musa-dsl'

require_relative 'keyboard-instrument'

class TheGrandeurPiano < Piano
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch('c-1')..pitch('c7')
    @polyphony = 3
  end
end
