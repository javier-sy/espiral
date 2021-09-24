require 'musa-dsl'

require_relative 'instrument'

using Musa::Extension::InspectNice

class TunedPercussion_BBC < Instrument
  def initialize(techniques_set, name, midi_voices:, tick_duration:, logger:)
    all = (techniques_set == :all) # tubular bells
    a = (techniques_set == :a) # marimba, glockenspiel
    b = (techniques_set == :b) # vibraphone

    @techniques = {
      [:hits, [:short, :hits]] => 0,
      [:hits_dumped, [:short, :hits, :dumped]] => (2 if all),
      [:rolls, [:long, :rolls]] => (1 if all || a),
    }.delete_if { |_, v| v.nil? }

    super(name, midi_voices: midi_voices, tick_duration: tick_duration, logger: logger)
  end
end

class AllTechniquesTunedPercussion_BBC < TunedPercussion_BBC
  def initialize(...)
    super(:all, ...)
  end
end

class ATechniquesTunedPercussion_BBC < TunedPercussion_BBC
  def initialize(...)
    super(:a, ...)
  end
end

class BTechniquesTunedPercussion_BBC < TunedPercussion_BBC
  def initialize(...)
    super(:b, ...)
  end
end
