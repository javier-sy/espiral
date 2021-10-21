require 'musa-dsl'

require_relative 'string-instrument-bbc'

class Violin < LeaderStringInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('g3')..pitch('c#7')
    @harmonics_pitch_range = pitch('g5')..pitch('c#8')
    super
  end
end

class Violins < SectionStringInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('g3')..pitch('c#7')
    @harmonics_pitch_range = pitch('g5')..pitch('c#8')
    super
  end
end

class Viola < LeaderStringInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c3')..pitch('f#6')
    @harmonics_pitch_range = pitch('c5')..pitch('f#7')
    super
  end
end

class Violas < SectionStringInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c3')..pitch('f#6')
    @harmonics_pitch_range = pitch('c5')..pitch('f#7')
    super
  end
end

class Cello < LeaderStringInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c2')..pitch('a#5')
    @harmonics_pitch_range = pitch('c4')..pitch('d#7')
    super
  end
end

class Cellos < SectionStringInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c2')..pitch('a#5')
    @harmonics_pitch_range = pitch('c4')..pitch('d#7')
    super
  end
end

class Contrabass < LeaderStringInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c1')..pitch('f#3')
    @harmonics_pitch_range = pitch('c3')..pitch('f#5')
    super
  end
end

class Contrabasses < SectionStringInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c1')..pitch('f#3')
    @harmonics_pitch_range = pitch('c3')..pitch('f#5')
    super
  end
end
