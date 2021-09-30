require 'musa-dsl'

require_relative 'brass-instrument-bbc'

class FrenchHorn < AllTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("e2")..pitch("f5")
  end
end

class FrenchHorns < FrenchHorn; end

class Trumpet < AllTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("e3")..pitch("c6")
  end
end

class Trumpets < Trumpet; end

class TenorTrombone < ATechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("g1")..pitch("d5")
  end
end

class TenorTrombones < TenorTrombone; end

class BassTrombones < ATechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("e1")..pitch("g4")
  end
end

class Tuba < ANoMutedTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("d1")..pitch("e4")
  end
end

class ContrabassTuba < BTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("d1")..pitch("c4")
  end
end

class ContrabassTrombone < BTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("e1")..pitch("g4")
  end
end

class Cimbasso < CTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("e0")..pitch("e3")
  end
end
