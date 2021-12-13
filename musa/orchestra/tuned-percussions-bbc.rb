require 'musa-dsl'

require_relative 'tuned-percussion-bbc'

class TubularBells < AllTechniquesTunedPercussion_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c#4')..pitch('g5')
    @best_pitch_range = pitch('c#4')..pitch('f5')
    @polyphony = 2
    super
  end
end

class Marimba < ATechniquesTunedPercussion_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c2')..pitch('c7')
    @polyphony = 2
    super
  end
end

class Glockenspiel < ATechniquesTunedPercussion_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('g5')..pitch('c8')
    @polyphony = 2
    super
  end
end

class Vibraphone < BTechniquesTunedPercussion_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('f3')..pitch('f6')
    @polyphony = 4
    super
  end
end
