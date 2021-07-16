require 'musa-dsl'

require_relative 'instrument'

using Musa::Extension::InspectNice

class BrassInstrument_BBC < Instrument
  def initialize(techniques_set, name, midi_voices:, tick_duration:, logger:)
    all = (techniques_set == :all)  # horns and trumpets
    a = (techniques_set == :a) # trombones
    a_no_muted = (techniques_set == :a_no_muted) # tuba
    b = (techniques_set == :b) # contrabass trombone and contrabass tuba
    c = (techniques_set == :c) # cimbasso

    @techniques = {
      [:staccato_muted, :stmt, [:short, :staccato, :muted]] => (11 if all || a),
      [:staccato, :st, [:short, :staccato]] => 2,
      [:marcato_muted, [:short, :marcato, :muted]] => (12 if all || a),
      [:marcato, [:short, :marcato]] => 3,
      [:multitongue, [:short, :multitongue]] => ({ key_switch: 7, modulators: [:repeats] } if all || a || a_no_muted),

      [:long_muted, :muted, :mt, [:long, :muted]] => (10 if all || a),
      [:long] => 1,
      [:long_fltr, :fltr, [:long, :flutter]] => (6 if all || a || a_no_muted),
      [:sforzando, :sfz, [:long, :sfz]] => 5,
      [:cuivre, [:long, :cuivre]] => 4,

      # no incluyo los trills porque no son técnicas sino ornamentaciones
      #
      # [:trill_2M, [:long, :trill, :M2], [:trill, :M2]] => (8 if all),
      # [:trill_2m, [:long, :trill, :m2], [:trill, :m2]] => (9 if all),

      [:legato, :lg] => (0 if all || a || b || a_no_muted),

    }.delete_if { |_, v| v.nil? }

    super(name, midi_voices: midi_voices, tick_duration: tick_duration, logger: logger)
  end
end

class AllTechniquesBrassInstrument_BBC < BrassInstrument_BBC
  def initialize(...)
    super(:all, ...)
  end
end

class ATechniquesBrassInstrument_BBC < BrassInstrument_BBC
  def initialize(...)
    super(:a, ...)
  end
end

class ANoMutedTechniquesBrassInstrument_BBC < BrassInstrument_BBC
  def initialize(...)
    super(:a_no_muted, ...)
  end
end

class BTechniquesBrassInstrument_BBC < BrassInstrument_BBC
  def initialize(...)
    super(:b, ...)
  end
end

class CTechniquesBrassInstrument_BBC < BrassInstrument_BBC
  def initialize(...)
    super(:c, ...)
  end
end