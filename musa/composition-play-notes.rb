require_relative 'composition-spirals'

class CompositionWithNotesPlaying < CompositionWithSpirals
  def initialize(real_clock: nil, do_voices_log: nil)
    super
    @chromatic_scale = Scales.default_system.default_tuning.chromatic[0]
  end

  protected def render_to_midi(level2:, level3:, values:, duration:)
    super

    if values[0]
      # interpretamos los valores como [pitch/velocity, velocity/pitch, time]
      quantized_duration =
        duration.collect { |d| @sequencer.quantize_position(@sequencer.position + d) - @sequencer.position if d }

      note = { grade: (84 + values[0]).to_i,
               duration: quantized_duration[0],
               velocity: (@level3_z[level2][level3] / 6r).to_i - 3,
               voice: "#{level2}-#{level3}" }.extend(GDV)

      instrument = @pool.find_free

      technique = instrument.find_techniques(:legato).first
      technique ||= instrument.find_techniques(:long).first
      technique ||= instrument.find_techniques(:short).first

      raise "Cannot find a technique for #{instrument.name}!!!!" unless technique

      note[technique.id] = true

      instrument.note **note.to_pdv(@chromatic_scale).tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }
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

CompositionWithNotesPlaying.new(real_clock: true).run(only_draw_matrixes: false)

