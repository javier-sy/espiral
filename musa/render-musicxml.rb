require 'musa-dsl'

class RenderMusicXML
  using Musa::Extension::Matrix
  using Musa::Extension::InspectNice

  Rational.to_s_as_inspect = true

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

      s.play_timed(line) do |value, time:, next_value:, duration:, started_ago:|
        quantized_duration = {}

        duration.each_pair do |component, value|
          quantized_duration[component] = s.quantize_position(time + value) - s.position if value
        end

        logger.debug
        logger.debug "new element at position #{s.position.inspect}\n" \
              "\t\tvalue #{value}\n" \
              "\t\tnext #{next_value}\n" \
              "\t\tduration #{duration}\n" \
              "\t\tquantized_duration #{quantized_duration}\n" \
              "\t\tstarted_ago #{started_ago}\n"

        new_instrument_now = !!duration[:instrument]
        new_dynamics_now = !!duration[:dynamics]
        new_pitch_now = !!duration[:pitch]

        logger.debug
        logger.debug "new_dynamics_now #{new_dynamics_now} new_instrument_now #{new_instrument_now} new_pitch_now #{new_pitch_now}"

        value.each_pair do |component, value|
          values[component] = value
        end

        next_value.each_pair do |component, value|
          next_values[component] = value
        end

        quantized_duration.each_pair do |component, duration|
          quantized_durations[component] = duration
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

            logger.debug "start_instrument_position #{start_instrument_position&.inspect || 'nil'}"
            logger.debug "finish_instrument_position #{finish_instrument_position&.inspect || 'nil'}"

            start_dynamics_position = s.position - (started_ago[:dynamics] || 0)
            finish_dynamics_position = start_dynamics_position + quantized_durations[:dynamics]

            logger.debug "start_dynamics_position #{start_dynamics_position&.inspect || 'nil'}"
            logger.debug "finish_dynamics_position #{finish_dynamics_position&.inspect || 'nil'}"

            segment_q_effective_duration =
                [finish_instrument_position, finish_dynamics_position].compact.min - s.position

            segment_effective_finish_position = s.position + segment_q_effective_duration

            logger.debug "segment_effective_finish_position #{segment_effective_finish_position&.inspect || 'nil'}"

            # relative start and finish position are ratios from 0 (beginning) to 1 (finish)
            #

            # for instrument
            #
            segment_relative_start_position_over_instrument_timeline =
                Rational(s.position - start_instrument_position,
                         finish_instrument_position - start_instrument_position)

            segment_relative_finish_position_over_instrument_timeline =
                Rational(segment_effective_finish_position - start_instrument_position,
                         finish_instrument_position - start_instrument_position)

            # for dynamics
            #
            if finish_dynamics_position > start_dynamics_position
              segment_relative_start_position_over_dynamics_timeline =
                  Rational(s.position - start_dynamics_position,
                           finish_dynamics_position - start_dynamics_position)

              segment_relative_finish_position_over_dynamics_timeline =
                  Rational(segment_effective_finish_position - start_dynamics_position,
                           finish_dynamics_position - start_dynamics_position)
            else
              segment_relative_start_position_over_dynamics_timeline = 1
              segment_relative_finish_position_over_dynamics_timeline = 1
            end

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

            logger.debug "segment_relative_start_position_over_dynamics_timeline #{segment_relative_start_position_over_dynamics_timeline&.inspect || 'nil'}"
            logger.debug "segment_relative_finish_position_over_dynamics_timeline #{segment_relative_finish_position_over_dynamics_timeline&.inspect || 'nil'}"

            logger.debug "values[:dynamics] #{values[:dynamics].to_f.round(2)} delta_dynamics #{delta_dynamics.to_f.round(2)}"

            if from_instrument && to_instrument
              logger.debug "rendering dynamics for instrument change: new_dynamics_now #{new_dynamics_now} new_instrument_now #{new_instrument_now}..."

              render_dynamics segment_from_dynamics_from_instrument,
                              segment_to_dynamics_from_instrument,
                              segment_q_effective_duration,
                              score: score,
                              instrument: from_instrument_symbol,
                              position: s.position,
                              logger: s.logger

              render_dynamics segment_from_dynamics_to_instrument,
                              segment_to_dynamics_to_instrument,
                              segment_q_effective_duration,
                              score: score,
                              instrument: to_instrument_symbol,
                              position: s.position,
                              logger: s.logger
            end

            if from_instrument && !to_instrument
              logger.debug "rendering dynamics without instrument change: new_dynamics_now #{new_dynamics_now} new_instrument_now #{new_instrument_now}..."

              render_dynamics segment_from_dynamics,
                              segment_to_dynamics,
                              segment_q_effective_duration,
                              score: score,
                              instrument: from_instrument_symbol,
                              position: s.position,
                              logger: s.logger
            end
          end

          logger.debug "pitch #{pitch}"
          logger.debug "q_duration_pitch #{q_duration_pitch.inspect} q_duration_dynamics #{q_duration_dynamics.inspect} q_duration_instrument #{q_duration_instrument.inspect}"
          logger.debug "started_ago #{started_ago.inspect}"

          q_effective_duration_pitch = [
              q_duration_pitch - (started_ago[:pitch] || 0),
              q_duration_dynamics - (started_ago[:dynamics] || 0),
              q_duration_instrument && (q_duration_instrument - (started_ago[:instrument] || 0))].compact.min

          logger.debug "effective_duration_pitch #{q_effective_duration_pitch.inspect}"

          render_pitch pitch,
                       q_effective_duration_pitch,
                       score: score,
                       instrument: from_instrument_symbol,
                       position: s.position,
                       logger: logger

          if to_instrument
            render_pitch pitch,
                         q_effective_duration_pitch,
                         score: score,
                         instrument: to_instrument_symbol,
                         position: s.position,
                         logger: logger
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
                                  vln5: { name: 'Violin 5', abbreviation: 'vln5', clefs: { g: 2 } },
                                  vln6: { name: 'Violin 6', abbreviation: 'vln6', clefs: { g: 2 } },
                                  vln7: { name: 'Violin 7', abbreviation: 'vln7', clefs: { g: 2 } },
                                  vln8: { name: 'Violin 8', abbreviation: 'vln8', clefs: { g: 2 } },
                                  cello1: { name: 'Cello 1', abbreviation: 'cello1', clefs: { f: 4 } },
                                  cello2: { name: 'Cello 2', abbreviation: 'cello2', clefs: { f: 4 } },
                                  cello3: { name: 'Cello 3', abbreviation: 'cello3', clefs: { f: 4 } },
                                  cello4: { name: 'Cello 4', abbreviation: 'cello4', clefs: { f: 4 } },
                                  cello5: { name: 'Cello 5', abbreviation: 'cello5', clefs: { f: 4 } },
                                  cello6: { name: 'Cello 6', abbreviation: 'cello6', clefs: { f: 4 } },
                                  cello7: { name: 'Cello 7', abbreviation: 'cello7', clefs: { f: 4 } },
                                  cello8: { name: 'Cello 8', abbreviation: 'cello8', clefs: { f: 4 } },
                         },
                         do_log: true)

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

    if (1..8).cover?(number)
      "vln#{number.to_i.to_s}".to_sym
    elsif (9..16).cover?(number)
      "cello#{(number.to_i - 8).to_s}".to_sym
    else
      :unknown
    end
  end

  private def render_dynamics(dynamics0, dynamicsF, duration, score:, instrument:, position:, logger:)
    dynamicsF ||= dynamics0

    score.at position,
             add: d = { instrument: instrument,
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

    di = d.inspect
    logger.debug "render_dynamics: #{di}"
  end

  def render_pitch(pitch, duration, score:, instrument:, position:, logger:)
    if duration < 0
      logger.error "negative duration #{duration} at #{position.inspect}: pitch #{pitch} duration #{duration} instrument #{instrument}"
      logger.error "ignoring negative duration note"

      duration = 0

      # raise RuntimeError, "negative duration at #{position.inspect}: pitch #{pitch} duration #{duration} instrument #{instrument}"
    end

    if duration > 0
      { instrument: instrument,
        pitch: pitch,
        duration: duration }.extend(PDV).tap { |note| score.at position, add: note }
    end
  end
end