require 'musa-dsl'

require_relative 'brass-instrument-bbc'

class FrenchHorn < AllTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('e2')..pitch('f5')
    @best_pitch_range = pitch('c3')..pitch('c5')
    super
  end
end

class FrenchHorns < FrenchHorn; end

class Trumpet < AllTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('e3')..pitch('c6')
    @best_pitch_range = pitch('c4')..pitch('b-5')
    super
  end
end

class Trumpets < Trumpet; end

class TenorTrombone < ATechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('g1')..pitch('d5')
    @best_pitch_range = pitch('a2')..pitch('f4')
    super
  end
end

class TenorTrombones < TenorTrombone; end

class BassTrombones < ATechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('e1')..pitch('g4')
    @best_pitch_range = pitch('b-1')..pitch('b-4')
    super
  end
end

class ContrabassTrombone < BTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('e1')..pitch('g4')
    @best_pitch_range = pitch('e1')..pitch('b2') # lo he deducido, no aparece en la referencia que uso
    super
  end
end

class Cimbasso < CTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('e0')..pitch('e3')
    @best_pitch_range = pitch('e0')..pitch('b2')
    super
  end
end

class Tuba < ANoMutedTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('d1')..pitch('e4')
    @best_pitch_range = pitch('c2')..pitch('g3')
    super
  end
end

class ContrabassTuba < BTechniquesBrassInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('d1')..pitch('c4')
    @best_pitch_range = pitch('d1')..pitch('g2') # lo he deducido, no aparece en la referencia que uso
    super
  end
end
