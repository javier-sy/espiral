require 'musa-dsl'

require_relative '../lib/instrument'

using Musa::Extension::InspectNice

class Keyboard < Instrument
  def initialize(techniques_set, name, midi_voices:, tick_duration:, logger:)
    has_legato = (techniques_set == :has_legato)

    @techniques_groups = {
      standard: [:staccato, :standard, (:legato if has_legato)]
    }
    @techniques = {
      [:staccato, :st, [:short, :staccato]] => -1,
      [:standard, [:long, :standard]] => -1,
      # [:accent, :ac] => -1, # :accent is not a technique but a modification for another one; not implemented
      [:legato] => (-1 if has_legato),
    }.delete_if { |_, v| v.nil? }

    @polyphony = 10

    super(name, midi_voices: midi_voices, tick_duration: tick_duration, logger: logger)
  end

  protected def calculate_technique(pitch, duration, velocity, techniques)
    staccato = techniques[:staccato]
    standard = techniques[:standard]
    legato = techniques[:legato]
    accent = techniques[:accent] # accent is not used

    counter = 0

    counter += 1 if staccato
    counter += 1 if standard
    counter += 1 if legato

    raise ArgumentError, "Cannot use more than one articulation at the same time" if counter > 1

    staccato = 1 if staccato == true
    standard = 1 if standard == true
    legato = 1 if legato == true
    accent = 1 if accent == true

    standard = 1r if counter == 0

    if staccato
      effective_duration = (@tick_duration * 8r) / (2 ** staccato.to_r)
    end

    if legato
      effective_duration = duration + @tick_duration * (2 ** legato.to_r)
    end

    if standard
      effective_duration = duration * (2 ** standard.to_r / (2 ** standard.to_r + 1))
    end

    if accent
      effective_velocity = velocity + (127 - velocity) * accent.to_r
    else
      effective_velocity = velocity
    end

    effective_velocity = 127 if effective_velocity > 127
    effective_velocity = 0 if effective_velocity < 0

    # Low notes on a keyboard instrument have longer resonance than high notes
    #
    max_effective_duration = 1 + (pitch / 127r) * 2

    effective_duration = max_effective_duration if effective_duration > max_effective_duration

    return technique(:standard), effective_duration, effective_velocity
  end
end

class Harpsichord < Keyboard
  def initialize(...)
    super(nil, ...)
  end

end

class Piano < Keyboard
  def initialize(...)
    super(:has_legato, ...)
  end
end
