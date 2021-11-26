require 'musa-dsl'

require_relative '../lib/instrument'

using Musa::Extension::InspectNice

class WoodwindInstrument_BBC < Instrument
  def initialize(techniques_set, name, midi_voices:, tick_duration:, logger:)
    all = (techniques_set == :all) # piccolo
    a = (techniques_set == :a) # flutes and clarinets
    b = (techniques_set == :b) # bassoons
    c = (techniques_set == :c) # contrabass clarinet, contrabasson & bass clarinet
    d = (techniques_set == :d) # oboes
    e = (techniques_set == :e) # cor anglais
    f = (techniques_set == :f) # bass flute

    @techniques_groups = {
      short: [:staccato, (:tenuto if all || b || c || d || e || f), :marcato].compact,
      long: [:legato, (:long_fltr if all || a || b || c)].compact,
      long_multi_note: [:trill_2m, :trill_2M],
      fx: [:rips, :falls]
    }

    @techniques = {
      [:staccato, :st, [:short, :staccato]] => 4,
      [:tenuto, :t, [:short, :tenuto]] => (5 if all || b || c || d || e || f),
      [:marcato, [:short, :marcato]] => 6,
      [:multitongue, [:short, :multitongue]] => ({ key_switch: 8, modulators: [:repeats] } if all || c || d),

      [:long] => { key_switch: 1, modulators: [:vibrato] },
      [:long_fltr, :fltr, [:long, :flutter]] => ({ key_switch: 7 } if all || a || b || c),

      [:trill_2M, [:long, :trill, :M2], [:trill, :M2]] => 2,
      [:trill_2m, [:long, :trill, :m2], [:trill, :m2]] => 3,

      [:rips, [:long, :rips]] => { key_switch: 9, modulators: [:speed] },
      [:falls, [:long, :falls]] => { key_switch: 10, modulators: [:speed] },

      [:legato, :lg] => { key_switch: 0, modulators: [:vibrato] },

    }.delete_if { |_, v| v.nil? }

    super(name, midi_voices: midi_voices, tick_duration: tick_duration, logger: logger)
  end
end

class AllTechniquesWWInstrument_BBC < WoodwindInstrument_BBC
  def initialize(...)
    super(:all, ...)
  end
end

class ATechniquesWWInstrument_BBC < WoodwindInstrument_BBC
  def initialize(...)
    super(:a, ...)
  end
end

class BTechniquesWWInstrument_BBC < WoodwindInstrument_BBC
  def initialize(...)
    super(:b, ...)
  end
end

class CTechniquesWWInstrument_BBC < WoodwindInstrument_BBC
  def initialize(...)
    super(:c, ...)
  end
end

class DTechniquesWWInstrument_BBC < WoodwindInstrument_BBC
  def initialize(...)
    super(:d, ...)
  end
end

class ETechniquesWWInstrument_BBC < WoodwindInstrument_BBC
  def initialize(...)
    super(:e, ...)
  end
end

class FTechniquesWWInstrument_BBC < WoodwindInstrument_BBC
  def initialize(...)
    super(:f, ...)
  end
end
