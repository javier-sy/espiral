require 'musa-dsl'

require_relative 'ww-instrument-bbc'

class Piccolo < AllTechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("d5")..pitch("c8")
  end
end

class Flute < ATechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("b3")..pitch("c7")
  end
end

class Flutes < Flute; end

class Clarinet < ATechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("d3")..pitch("e6")
  end
end

class Clarinets < Clarinet; end

class Bassoon < BTechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("b_1")..pitch("d5")
    @harmonics_pitch_range = pitch("g5")..pitch("c8")
  end
end

class Bassoons < Bassoon; end

class ContrabassClarinet < CTechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("b_0")..pitch("c4")
  end
end

class Contrabassoon < CTechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("c1")..pitch("b_3")
  end
end

class BassClarinet < CTechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("b_1")..pitch("e5")
  end
end

class Oboe < DTechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("b3")..pitch("f6")
  end
end

class Oboes < Oboe; end

class CorAnglais < ETechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("e3")..pitch("a5")
  end
end

class BassFlute < FTechniquesWWInstrument_BBC
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    super
    @pitch_range = pitch("c2")..pitch("c4")
  end
end
