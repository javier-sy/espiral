require_relative 'composition-4-spirals-runner'

class CompositionWithNotesPlaying < CompositionWithSpiralsRunner
  include Musa::Scales
  include Musa::Datasets

  def initialize(realtime: nil, render3d: nil, do_voices_log: nil, draw_level1: true, draw_level2: true, draw_level3: true)
    super
    @chromatic_scale = Scales.default_system.default_tuning.chromatic[0]
  end

  protected def render_to_midi_level2(level2:, values:, duration:)
    super

    if values[0]
      # interpretamos los valores como [pitch/velocity, velocity/pitch, time]
      quantized_duration =
        duration.compact.collect { |d| @sequencer.quantize_position(@sequencer.position + d) - @sequencer.position if d }

      note = { grade: (72 + values[0]).to_i,
               duration: quantized_duration.min,
               velocity: 0, # TODO change!!!! remember it's -5 to +5 range aprox (being a GDV)
               voice: "#{level2}" }.extend(GDV)

      pitch = note.to_pdv(@chromatic_scale)
      instrument = @orchestra.piano

      technique = instrument.find_techniques(:legato).first
      technique ||= instrument.find_techniques(:long).first
      technique ||= instrument.find_techniques(:short).first

      raise "Cannot find a technique for #{instrument.name}!!!!" unless technique

      note[technique.id] = true

      info "Rendering level 2 pitch #{pitch[:pitch]} velocity #{pitch[:velocity]} duration #{pitch[:duration].round(3)}"

      instrument.note **pitch.tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }
    end
  end

  protected def render_to_midi_level3(level2:, level3:, values:, duration:)
    super

    if values[0]
      # interpretamos los valores como [pitch/velocity, velocity/pitch, time]
      quantized_duration =
        duration.compact.collect { |d| @sequencer.quantize_position(@sequencer.position + d) - @sequencer.position if d }

      note = { grade: (60 + values[0]).to_i,
               duration: quantized_duration.min,
               velocity: 0, # TODO change!!!! remember it's -5 to +5 range aprox (being a GDV)
               voice: "#{level2}-#{level3}" }.extend(GDV)

      pitch = note.to_pdv(@chromatic_scale)

      # When level3 starts before level2 (this happens when level3 rotation ond folding makes it to start before level2)
      # @level2_x[level2] is nil. In this case I use the last previous value of the level2 last curve.
      #
      i = level2
      i -= 1 until @level2_x[i]

      warn "Calculating timbre: @level2_x[#{level2}] has not started yet, using @level2_x[#{i}]" if level2 != i

      timbre = ((@level2_x[i]) - @level2_box.x_min) / @level2_box.x_range

      instruments_pool = @instruments_pools[@level1_magnitude_ratio * @instruments_pools.size]
      instrument = instruments_pool.find_free_with(timbre: timbre, pitch: pitch[:pitch])

      debug "Searching instrument for center #{timbre} and pitch #{pitch[:pitch]} in #{instruments_pool.name}... found #{instrument&.name || 'NOT FOUND!!!'}"

      if instrument
        technique = instrument.find_techniques(:legato).first
        technique ||= instrument.find_techniques(:long).first
        technique ||= instrument.find_techniques(:short).first

        raise "Cannot find a technique for #{instrument.name}!!!!" unless technique

        note[technique.id] = true

        instrument.note **pitch.tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }
      else
        warn "Not found instrument for timbre #{timbre} and pitch #{pitch[:pitch]} in instrument set #{instruments_pool}"
      end
    end
  end

  private def put_in_pitch_range(instrument, pitch)
    new_pitch = pitch

    sign = pitch <=> instrument.pitch_range.last
    limit = sign.negative? ? instrument.pitch_range.first : instrument.pitch_range.last

    i = 0

    until instrument.pitch_range.include?(new_pitch)
      new_pitch = (pitch % 12) + ((limit / 12).to_i - i) * 12
      i += sign
    end

    warn "pitch #{pitch} no está incluido en el rango para #{instrument.name}... generando nota #{new_pitch}" if new_pitch != pitch

    new_pitch
  end
end
