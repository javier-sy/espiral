require 'mittsu'
require 'musa-dsl'
require 'unimidi'

require_relative 'probe-3d'
require_relative 'render-musicxml'
require_relative 'matrix-operations'
require_relative 'violin'

include Musa::Scales
include Musa::Series
include Musa::Datasets
include Musa::Clock
include Musa::Sequencer
include Musa::MIDIVoices

using Musa::Extension::Matrix
using Musa::Extension::InspectNice
using Musa::Extension::DeepCopy

#
# Configuration: number of threads to render to musicxml (nil for all)
#

threads = nil

#
# Compute spiral 3D matrix
#

rows = []
r = 0.0
# pitch/velocity, velocity/pitch, time
(0..1000).each do |z|
  x = Math.sin(r) * z / 70.0
  y = Math.cos(r) * z / 70.0
  rows << [x, y, z / 20.0]
  r += 0.1
end

m = Matrix[*rows]

# Rotate matrix
#
# r = MatrixOperations.rotation(0.45, 1, 1, 0)
# r = MatrixOperations.rotation(0.35, 0.5, 1, 0.3)
# r = MatrixOperations.rotation(0.25, 0.1, 1, 0.1) # interesante
# r = MatrixOperations.rotation(Math::PI/3, 0, 1, 0) # interesante
r = MatrixOperations.rotation(Math::PI/3, 0, 1, 0)

m = m * r

#
# Prepare transformations to score and MIDI
#

# Source quantization for MIDI and score instruments
#
midi_quantized_timed_series =
    m.to_p(time_dimension: 2, keep_time: true).collect do |line|
      TIMED_UNION(
          *line.to_timed_serie(time_start_component: 2, base_duration: 1)
               .flatten_timed
               .split
               .to_a
               .tap { |_| _.delete_at(2) } # we don't want time dimension itself to be quantized
               .collect { |_|
                 _.quantize(predictive: true, stops: false)
                     .anticipate { |_, c, n|
                       n ? c.clone.tap { |_| _[:next_value] = (c[:value].nil? || c[:value] == n[:value]) ? nil : n[:value] } :
                           c } }
      )
    end

violin_quantized_array_of_timed_series =
    m.to_p(time_dimension: 2, keep_time: true).collect.with_index do |line, i|
      Array[
          *line.to_timed_serie(time_start_component: 2, base_duration: 1)
               .map { |_| _.clone.tap { |_| _[:value][3] = (i % 8) + 1 } } # add instrument as line number
               .flatten_timed
               .split
               .to_a
               .tap { |_| _.delete_at(2) } # we don't want time dimension itself to be quantized
               .collect.with_index { |_, i|
                  case i
                  when 0 # pitch
                    _.quantize(predictive: true, stops: false, step: 1)
                        .map { |_| _.clone.tap { |_| _[:value] = 84 + _[:value] } }
                        .anticipate { |_, c, n| c.clone.tap { |_| _[:next_value] = n&.[](:value) } }
                  when 1 # dynamics
                    _.quantize(predictive: true, stops: false, step: 6)
                        .map { |_| _.clone.tap { |_| _[:value] = 7 + (_[:value] / 6r).to_i } }
                        .anticipate { |_, c, n| c.clone.tap { |_| _[:next_value] = n&.[](:value) } }
                  when 2 # instrument
                    _.quantize(stops: false)
                  end
                } ]
    end

violin_quantized_united_timed_series = violin_quantized_array_of_timed_series.collect { |lines| TIMED_UNION(*lines) }

cello_quantized_array_of_timed_series =
    m.to_p(time_dimension: 2, keep_time: true).collect.with_index do |line, i|
      Array[
          *line.to_timed_serie(time_start_component: 2, base_duration: 1)
               .map { |_| _.clone.tap { |_| _[:value][3] = (i % 8) + 9 } } # add instrument as line number
               .flatten_timed
               .split
               .to_a
               .tap { |_| _.delete_at(2) } # we don't want time dimension itself to be quantized
               .collect.with_index { |_, i|
                  case i
                  when 0 # dynamics
                    _.quantize(predictive: true, stops: false, step: 6)
                        .map { |_| _.clone.tap { |_| _[:value] = 7 + (_[:value] / 6r).to_i } }
                        .anticipate { |_, c, n| c.clone.tap { |_| _[:next_value] = n&.[](:value) } }
                  when 1 # pitch
                    _.quantize(predictive: true, stops: false, step: 1)
                        .map { |_| _.clone.tap { |_| _[:value] = 48 + _[:value] } }
                        .anticipate { |_, c, n| c.clone.tap { |_| _[:next_value] = n&.[](:value) } }
                  when 2 # instrument
                    _.quantize(stops: false)
                  end
          } ]
    end

cello_quantized_united_timed_series = cello_quantized_array_of_timed_series.collect { |lines| TIMED_UNION(*lines) }

#
# Quantized series transformation to playable datasets for score instruments
#

violin_score_quantized_timed_series =
    violin_quantized_united_timed_series.clone(deep: true).collect do |line|
      TIMED_UNION(
          **line.map { |_|
                { time: _[:time],
                  value: {
                      pitch: _[:value][0],
                      dynamics: _[:value][1],
                      instrument: _[:value][2] },
                  duration: {
                      pitch: _[:duration][0],
                      dynamics: _[:duration][1],
                      instrument: _[:duration][2] },
                  next_value: {
                      pitch: _[:next_value][0],
                      dynamics: _[:next_value][1],
                      instrument: _[:next_value][2] }
                  }.extend(AbsTimed)
          }.flatten_timed
           .split
           .to_h
      )
    end

cello_score_quantized_timed_series =
    cello_quantized_united_timed_series.clone(deep: true).collect do |line|
      TIMED_UNION(
          **line.map { |_|
            { time: _[:time],
              value: {
                  dynamics: _[:value][0],
                  pitch: _[:value][1],
                  instrument: _[:value][2] },
              duration: {
                  dynamics: _[:duration][0],
                  pitch: _[:duration][1],
                  instrument: _[:duration][2] },
              next_value: {
                  dynamics: _[:next_value][0],
                  pitch: _[:next_value][1],
                  instrument: _[:next_value][2] }
            }.extend(AbsTimed)
          }.flatten_timed
                .split
                .to_h
      )
    end

#
# Render to score
#

renderer = RenderMusicXML.new
score = Score.new

violin_score_quantized_timed_series[0..threads&.-(1)].each_with_index do |serie, i|
  puts
  puts msg = "rendering segment #{i} (violin #{(i % 8) + 1})"
  puts "-" * msg.size

  renderer.render(serie, to: score)
end

cello_score_quantized_timed_series[0..threads&.-(1)].each_with_index do |serie, i|
  puts
  puts msg = "rendering segment #{i} (cello #{(i % 8) + 1})"
  puts "-" * msg.size

  renderer.render(serie, to: score)
end

puts
puts "SCORE"
puts "-----"
pp score

#
# Render to musicxml file
#

# renderer.render_score(4, 4, score)

#################################
# 3D graphics and MIDI playback #
#################################

#
# Sequencer and logging setup
#

clock = TimerClock.new ticks_per_beat: 4, bpm: 90
sequencer = Sequencer.new 4, 4

sequencer.logger.info!

#
# 3D rendering setup and base drawing
#

probe = Probe3D.new(10, logger: sequencer.logger)

probe.render_matrix(m, color: 0xa0a0a0)

#
# MIDI rendering
#

puts "midi_quantized_timed_series.size #{midi_quantized_timed_series.size}"

midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[0]

violin_midi_voices = MIDIVoices.new(sequencer: sequencer, output: midi_output, channels: 0..7)
cello_midi_voices = MIDIVoices.new(sequencer: sequencer, output: midi_output, channels: 8..15)

violin = Violin.new('violin',
                    midi_voices: violin_midi_voices.voices,
                    tick_duration: sequencer.tick_duration,
                    logger: sequencer.logger)

cello = Violin.new('cello',
                   midi_voices: cello_midi_voices.voices,
                   tick_duration: sequencer.tick_duration,
                   logger: sequencer.logger)

chromatic_scale = Scales.default_system.default_tuning.chromatic[0]

Thread.new do
  coordinates = []

  sequencer.at 1 do
    midi_quantized_timed_series.each_with_index do |quantized_timed_serie, i|
      sequencer.play_timed quantized_timed_serie do |values, duration:|

        quantized_duration =
            duration.collect { |d| sequencer.quantize_position(sequencer.position + d) - sequencer.position if d }

        coordinates[i] = [values[0] || coordinates[i][0], values[1] || coordinates[i][1], sequencer.position - 1r]

        probe.render_point(i, coordinates[i], color: 0x0fffff)

        if values[0]
          note = { grade: (84 + values[0]).to_i,
                   duration: quantized_duration[0],
                   velocity: (coordinates[i][1] / 6r).to_i - 3,
                   legato: true,
                   voice: i }.extend(GDV)

          violin.note **note.to_pdv(chromatic_scale)
        end

        if values[1]
          note = { grade: (48 + values[1]).to_i,
                   duration: quantized_duration[1],
                   velocity: (coordinates[i][0] / 6r).to_i - 3,
                   legato: true,
                   voice: i }.extend(GDV)

          cello.note **note.to_pdv(chromatic_scale)
        end
      end
    end
  end

  Thread.new { clock.run { sequencer.tick } }

  sleep 0.1
  clock.start
end

probe.run
clock.stop

