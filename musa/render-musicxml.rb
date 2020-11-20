require 'musa-dsl'

class RenderMusicXML
  using Musa::Extension::Matrix

  # line should be a timed_serie with values packed_V with :pitch, :dynamics, :instrument
  #
  def render(line, to:)
    beats_per_bar = 4r
    ticks_per_beat = 4r

    s = BaseSequencer.new beats_per_bar, ticks_per_beat, do_log: true, do_error_log: true
    logger = s.logger
    score = to

    s.at 1 do
      values = {}
      next_values = {}
      quantized_durations = {}

      s.play_timed(line) do |value, next_value:, duration:, started_ago:|
        quantized_duration =
            duration.keys.collect do |component|
              [component, s.quantize_position(s.position + duration[component]) - s.position]
            end.to_h

        logger.debug
        logger.debug "new element at position #{s.position.inspect}\n\t\tvalue #{value}\n\t\tnext #{next_value}\n\t\tduration #{duration}" \
             "\n\t\tquantized_duration #{quantized_duration}\n\t\tstarted_ago #{started_ago}\n"

        new_instrument_now = !started_ago[:instrument]
        new_dynamics_now = !started_ago[:dynamics]
        new_pitch_now = !started_ago[:pitch]

        # logger.debug
        # logger.debug "new_dynamics_now #{new_dynamics_now} new_instrument_now #{new_instrument_now} new_pitch_now #{new_pitch_now}"

        quantized_duration.each_pair do |component, duration|
          quantized_durations[component] = duration
        end

        value.each_pair do |component, value|
          values[component] = value
        end

        next_value.each_pair do |component, value|
          next_values[component] = value
        end

        if new_instrument_now || new_dynamics_now || new_pitch_now

          q_duration_instrument = quantized_durations[:instrument]
          q_duration_dynamics = quantized_durations[:dynamics]
          q_duration_pitch = quantized_durations[:pitch]

          from_instrument = values[:instrument]
          to_instrument = next_values[:instrument]

          from_instrument_symbol = instrument_number_to_symbol(from_instrument)
          to_instrument_symbol = instrument_number_to_symbol(to_instrument)

          to_dynamics = next_values[:dynamics]

          pitch = values[:pitch]

          if new_instrument_now || new_dynamics_now

            start_instrument_position = s.position - (started_ago[:instrument] || 0)
            finish_instrument_position = start_instrument_position + quantized_durations[:instrument]

            start_dynamics_position = s.position - (started_ago[:dynamics] || 0)
            finish_dynamics_position = start_dynamics_position + quantized_durations[:dynamics]

            segment_q_effective_duration =
                [finish_instrument_position, finish_dynamics_position].min - s.position

            segment_effective_finish_position = s.position + segment_q_effective_duration

            # relative start and finish position are ratios from 0 (beginning) to 1 (finish)
            #
            segment_relative_start_position_over_instrument_timeline =
                Rational(s.position - start_instrument_position,
                         finish_instrument_position - start_instrument_position)

            segment_relative_finish_position_over_instrument_timeline =
                Rational(segment_effective_finish_position - start_instrument_position,
                         finish_instrument_position - start_instrument_position)
            #
            segment_relative_start_position_over_dynamics_timeline =
                Rational(s.position - start_dynamics_position,
                         finish_dynamics_position - start_dynamics_position)

            segment_relative_finish_position_over_dynamics_timeline =
                Rational(segment_effective_finish_position - start_dynamics_position,
                         finish_dynamics_position - start_dynamics_position)

            delta_dynamics = (next_values[:dynamics] || values[:dynamics]) - values[:dynamics]

            segment_from_dynamics =
                values[:dynamics] +
                    delta_dynamics * segment_relative_start_position_over_dynamics_timeline

            segment_to_dynamics =
                values[:dynamics] +
                    delta_dynamics * segment_relative_finish_position_over_dynamics_timeline

            segment_from_dynamics_from_instrument =
                segment_from_dynamics *
                    (1r - segment_relative_start_position_over_instrument_timeline)

            segment_to_dynamics_from_instrument =
                segment_to_dynamics *
                    (1r - segment_relative_finish_position_over_instrument_timeline)

            segment_from_dynamics_to_instrument =
                segment_from_dynamics *
                    segment_relative_start_position_over_instrument_timeline

            segment_to_dynamics_to_instrument =
                segment_to_dynamics *
                    segment_relative_finish_position_over_instrument_timeline

            # logger.debug "from_instrument #{from_instrument_symbol} to_instrument #{to_instrument_symbol || 'nil'}"
            #
            # logger.debug "segment_q_effective_duration #{segment_q_effective_duration&.inspect || 'nil'}"
            #
            # logger.debug "segment_relative_start_position_over_dynamics_timeline #{segment_relative_start_position_over_dynamics_timeline&.to_f&.round(2) || 'nil'}"
            # logger.debug "segment_relative_finish_position_over_dynamics_timeline #{segment_relative_finish_position_over_dynamics_timeline&.to_f&.round(2) || 'nil'}"
            #
            # logger.debug "value[:dynamics] #{values[:dynamics].to_f.round(2)} delta_dynamics #{delta_dynamics.to_f.round(2)}"
            # logger.debug "segment_from_dynamics #{segment_from_dynamics.to_f.round(2)} to_dynamics #{to_dynamics.to_f.round(2)}"
            #
            # logger.debug "segment_relative_start_position_over_instrument_timeline #{segment_relative_start_position_over_instrument_timeline&.to_f&.round(2) || 'nil'}"
            # logger.debug "segment_relative_finish_position_over_instrument_timeline #{segment_relative_finish_position_over_instrument_timeline&.to_f&.round(2) || 'nil'}"
            #
            # logger.debug "#{from_instrument_symbol} segment_from_dynamics #{segment_from_dynamics_from_instrument.to_f.round(2)} to_dynamics #{segment_to_dynamics_from_instrument.to_f.round(2)}"
            # logger.debug "#{to_instrument_symbol || 'nil'} segment_from_dynamics #{segment_from_dynamics_to_instrument.to_f.round(2)} to_dynamics #{segment_to_dynamics_to_instrument.to_f.round(2)}"
            #
            if from_instrument && to_instrument
              render_dynamics segment_from_dynamics_from_instrument,
                              segment_to_dynamics_from_instrument,
                              segment_q_effective_duration,
                              score: score,
                              instrument: from_instrument_symbol,
                              position: s.position

              render_dynamics segment_from_dynamics_to_instrument,
                              segment_to_dynamics_to_instrument,
                              segment_q_effective_duration,
                              score: score,
                              instrument: to_instrument_symbol,
                              position: s.position
            end

            if from_instrument && !to_instrument
              render_dynamics segment_from_dynamics,
                              segment_to_dynamics,
                              segment_q_effective_duration,
                              score: score,
                              instrument: from_instrument_symbol,
                              position: s.position
            end
          end

          # logger.debug "pitch #{pitch}"

          q_effective_duration_pitch =
              [ q_duration_instrument - (started_ago[:instrument] || 0),
                q_duration_pitch - (started_ago[:pitch] || 0),
                q_duration_dynamics - (started_ago[:dynamics] || 0)].min

          # logger.debug "effective_duration_pitch #{q_effective_duration_pitch.inspect}"

          render_pitch pitch,
                       q_effective_duration_pitch,
                       score: score,
                       instrument: from_instrument_symbol,
                       position: s.position

          if to_instrument
            render_pitch pitch,
                         q_effective_duration_pitch,
                         score: score,
                         instrument: to_instrument_symbol,
                         position: s.position
          end
        end
      end
    end

    s.run

  end

  def render_score(beats_per_bar, ticks_per_beat, score)
    mxml = score.to_mxml(beats_per_bar, ticks_per_beat,
                         bpm: 90,
                         title: 'Espiral',
                         creators: { composer: 'Javier Sánchez Yeste' },
                         parts: { vln1: { name: 'Violin 1', abbreviation: 'vln1', clefs: { g: 2 } },
                                  vln2: { name: 'Violin 2', abbreviation: 'vln2', clefs: { g: 2 } },
                                  vln3: { name: 'Violin 3', abbreviation: 'vln3', clefs: { g: 2 } },
                                  vln4: { name: 'Violin 4', abbreviation: 'vln4', clefs: { g: 2 } },
                                  cello1: { name: 'Cello 1', abbreviation: 'cello1', clefs: { f: 4 } },
                                  cello2: { name: 'Cello 2', abbreviation: 'cello2', clefs: { f: 4 } },
                                  cello3: { name: 'Cello 3', abbreviation: 'cello3', clefs: { f: 4 } },
                                  cello4: { name: 'Cello 4', abbreviation: 'cello4', clefs: { f: 4 } }
                         },
                         do_log: false)

    f = File.join(File.dirname(__FILE__), "espiral.musicxml")
    File.open(f, 'w') { |f| f.write(mxml.to_xml.string) }
  end

  private def decode_instrument(instrument)
    instrument_1 = instrument.round
    instrument_2 = instrument_1 + (instrument <=> instrument_1)

    level_1 = (instrument_2 - instrument).round(Float::DIG).abs
    level_2 = (instrument_1 - instrument).round(Float::DIG).abs

    if instrument_1 == instrument_2
      { instrument_1 => 1 }
    else
      { instrument_1 => level_1, instrument_2 => level_2 }
    end
  end

  private def instrument_number_to_symbol(number)
    return nil if number.nil?
    "vln#{number.to_i.to_s}".to_sym
  end

  private def render_dynamics(dynamics0, dynamicsF, duration, score:, instrument:, position:)
    dynamicsF ||= dynamics0

    score.at position,
             add: { instrument: instrument,
                    type: case dynamicsF <=> dynamics0
                          when 1
                            :crescendo
                          when -1
                            :diminuendo
                          when 0
                            :dynamics
                          end,
                    from: dynamics0,
                    to: dynamicsF,
                    duration: duration }.extend(PS)
  end

  def render_pitch(pitch, duration, score:, instrument:, position:)
    { instrument: instrument,
      pitch: pitch,
      duration: duration }.extend(PDV).tap { |note| score.at position, add: note }
  end
end