require_relative 'composition-4-spirals-runner'

class CompositionWithNotesPlaying < CompositionWithSpiralsRunner
  include Musa::Scales
  include Musa::Datasets

  def initialize(realtime: nil, render3d: nil, do_voices_log: nil, draw_level1: true, draw_level2: true, draw_level3: true)
    super
    @chromatic_scale = Scales.default_system.default_tuning.chromatic[0]
  end

  protected def render_to_midi_level2(level2:, values:, velocity_ratio:, duration:)
    super

    if values[0]
      # interpretamos los valores como [pitch/velocity, velocity/pitch, time]
      quantized_duration =
        duration.compact.collect { |d| @sequencer.quantize_position(@sequencer.position + d) - @sequencer.position if d }

      note = { grade: (CENTER_PITCH + values[0]).to_i,
               duration: quantized_duration.min,
               velocity: (velocity_ratio * 6 +
                          ((values[1] - @level2_box.y_min) / @level2_box.y_range) * 3) - 3.0,
               voice: "#{level2}" }.extend(GDV)

      pitch = note.to_pdv(@chromatic_scale)
      instrument = @orchestra.piano

      technique = instrument.find_techniques(:legato).first
      technique ||= instrument.find_techniques(:long).first
      technique ||= instrument.find_techniques(:short).first

      raise "Cannot find a technique for #{instrument.name}!!!!" unless technique

      note[technique.id] = true

      info "Rendering level 2 pitch #{pitch[:pitch]} velocity #{pitch[:velocity]} duration #{pitch[:duration].round(3)}"

      instrument.note **pitch.tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }, bpm: @clock.bpm, level2: level2
    end
  end

  protected def render_to_midi_level3(level2:, level3:, values:, duration:)
    super

    if values[0]
      # When level3 starts before level2 (this happens when level3 rotation ond folding makes it to start before level2)
      # @level2_x[level2] is nil. In this case I use the last previous value of the level2 last curve.
      #
      i = level2
      i -= 1 until @level2_x[i]

      warn "Calculating timbre: @level2_x[#{level2}] has not started yet, using @level2_x[#{i}]" if level2 != i

      velocity_ratio = @level2_magnitude_ratio[i]

      # interpretamos los valores como [pitch/velocity, velocity/pitch, time]
      quantized_duration =
        duration.compact.collect { |d| @sequencer.quantize_position(@sequencer.position + d) - @sequencer.position if d }

      note = { grade: (CENTER_PITCH + values[0]).to_i,
               duration: quantized_duration.min,
               velocity: (velocity_ratio * 9) - 3.0, # remember it's -5.0 to +4.0 range (being a GDV)
               voice: "#{level2}-#{level3}" }.extend(GDV)

      pitch = note.to_pdv(@chromatic_scale)

      timbre = ((@level2_x[i]) - @level2_box.x_min) / @level2_box.x_range

      # articulation1 = ((@level2_y[i]) - @level2_box.y_min) / @level2_box.y_range
      articulation1 = ((level2 % LEVEL3_ARTICULATION_GROUP_ROTATION_SIZE) / LEVEL3_ARTICULATION_GROUP_ROTATION_SIZE)

      instruments_pool = @instruments_pools[@level1_magnitude_ratio * @instruments_pools.size]
      instrument = instruments_pool.find_free_with(timbre: timbre, pitch: pitch[:pitch])

      # If not found an instrument on the "direct" instruments pool we search for an instrument on the complementary instruments pool
      #
      unless instrument
        info "Not found instrument for timbre #{timbre} and pitch #{pitch[:pitch]} in direct instruments pool #{instruments_pool}, searching in complementary instruments pool"

        instruments_pool = @instruments_pools[((@level1_magnitude_ratio - 0.5) % 1.0) * @instruments_pools.size]
        instrument = instruments_pool.find_free_with(timbre: timbre, pitch: pitch[:pitch])
      end

      if instrument
        articulation2 = (values[1] - @level3_inner_boxes[level2].y_min) / @level3_inner_boxes[level2].y_range

        techniques_group = instrument.techniques_groups.values[articulation1 * (instrument.techniques_groups.size - 1).round]
        technique = instrument.technique(techniques_group[articulation2 * (techniques_group.size - 1).round])

        info "selecting articulation #{articulation1.round(2)}:#{articulation2.round(2)} for #{instrument.name}: #{technique&.id || 'nil'}"

        if technique.nil?
          technique = instrument.find_techniques(:legato).first
          technique ||= instrument.find_techniques(:long).first
          technique ||= instrument.find_techniques(:short).first

          warn "using default articulation for #{instrument.name}: #{technique.id}"
        end

        raise "Cannot find a technique #{articulation1.round(2)}:#{articulation2.round(2)} for #{instrument.name}!!!!" unless technique

        pitch[technique.id] = true

        instrument.note **pitch.tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }, bpm: @clock.bpm, level2: level2, level3: level3
      else
        warn "Not found alternative instrument for timbre #{timbre} and pitch #{pitch[:pitch]} in instruments pool #{instruments_pool}"
        @missing_instruments ||= {}
        @missing_instruments[instruments_pool.name] ||= 0
        @missing_instruments[instruments_pool.name] += 1

        info "Missing instruments: #{@missing_instruments}"
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
