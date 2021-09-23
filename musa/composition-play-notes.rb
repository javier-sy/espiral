require_relative 'composition-spirals'

class CompositionWithNotesPlaying < CompositionWithSpirals
  def initialize(real_clock: nil, do_voices_log: nil, draw_level1: true, draw_level2: true, draw_level3: true)
    super
    @chromatic_scale = Scales.default_system.default_tuning.chromatic[0]

    @instrument_sets = [@harmonic_instruments, @percussive_instruments, @percussive_instruments]
  end

  protected def render_to_midi_level2(level2:, values:, duration:)
    super

    if values[0]
      # interpretamos los valores como [pitch/velocity, velocity/pitch, time]
      quantized_duration =
        duration.collect { |d| @sequencer.quantize_position(@sequencer.position + d) - @sequencer.position if d }

      note = { grade: (60 + values[0]).to_i,
               duration: quantized_duration[0],
               velocity: 0, # TODO change!!!! remember it's -5 to +5 range aprox (being a GDV)
               voice: "#{level2}-#{level3}" }.extend(GDV)

      pitch = note.to_pdv(@chromatic_scale)
      instrument = @harpsichord

      technique = instrument.find_techniques(:legato).first
      technique ||= instrument.find_techniques(:long).first
      technique ||= instrument.find_techniques(:short).first

      raise "Cannot find a technique for #{instrument.name}!!!!" unless technique

      note[technique.id] = true

      instrument.note **pitch.tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }
    end
  end

  protected def render_to_midi_level3(level2:, level3:, values:, duration:)
    super

    if values[0]
      # interpretamos los valores como [pitch/velocity, velocity/pitch, time]
      quantized_duration =
        duration.collect { |d| @sequencer.quantize_position(@sequencer.position + d) - @sequencer.position if d }

      note = { grade: (60 + values[0]).to_i,
               duration: quantized_duration[0],
               velocity: 0, # TODO change!!!! remember it's -5 to +5 range aprox (being a GDV)
               voice: "#{level2}-#{level3}" }.extend(GDV)

      pitch = note.to_pdv(@chromatic_scale)

      # When level3 starts before level2 (this happens when level3 rotation ond folding makes it to start before level2)
      # @level2_x[level2] would be nil. In this case I use the last previous value of the level2 last curve.
      #
      if @level2_x[level2]
        timbre = ((@level2_x[level2]) - @level2_box.x_min) / @level2_box.x_range
      else
        timbre = ((@level2_x[level2 - 1]) - @level2_box.x_min) / @level2_box.x_range
        warn "Calculating timbre: @level2_x[#{level2}] has not started yet, using @level2_x[#{level2 - 1}]"
      end

      # instrument = @instrument_sets[level2 % @instrument_sets.size].find_free_with(timbre: timbre, pitch: pitch[:pitch])
      instrument = @harmonic_instruments.find_free_with(timbre: timbre, pitch: pitch[:pitch])

      debug "Searching instrument for center #{timbre}... found #{instrument&.name || 'NOT FOUND!!!'}"
      error "Not found instrument for timbre #{timbre}" unless instrument

      # instrument = @pool.find_free

      technique = instrument.find_techniques(:legato).first
      technique ||= instrument.find_techniques(:long).first
      technique ||= instrument.find_techniques(:short).first

      raise "Cannot find a technique for #{instrument.name}!!!!" unless technique

      note[technique.id] = true

      instrument.note **pitch.tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }
    end
  end

  private def put_in_pitch_range(instrument, pitch)
    if instrument.pitch_range.include?(pitch)
      new_pitch = pitch
    else
      new_pitch = (pitch % (instrument.pitch_range.max - instrument.pitch_range.min)) + instrument.pitch_range.min
      warn "pitch #{pitch} no está incluido en el rango para #{instrument.name}... generando nota #{new_pitch}"
    end

    new_pitch
  end

end

CompositionWithNotesPlaying.new(real_clock: false, draw_level1: false, draw_level2: true, draw_level3: false)
                           .run(only_draw_matrixes: false, draw_level1: false, draw_level2: false, draw_level3: true)
