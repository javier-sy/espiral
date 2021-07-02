require 'musa-dsl'

require_relative 'string-instrument-bbc'

class Violin < LeaderStringInstrument_BBC
  def initialize(name, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch("g3")..pitch("c7")
    @harmonics_pitch_range = pitch("g5")..pitch("c8")

    super
  end
end

class Viola < LeaderStringInstrument_BBC
  def initialize(name, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch("c3")..pitch("f6")
    @harmonics_pitch_range = pitch("c5")..pitch("f7")

    super
  end
end

class Cello < LeaderStringInstrument_BBC
  def initialize(name, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch("c2")..pitch("a5")
    @harmonics_pitch_range = pitch("c4")..pitch("d7")

    super
  end
end

class Bass < LeaderStringInstrument_BBC
  def initialize(name, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch("c1")..pitch("f3")
    @harmonics_pitch_range = pitch("c3")..pitch("f5")

    super
  end
end
