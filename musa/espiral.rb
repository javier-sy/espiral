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

r = MatrixOperations.rotation(0.45, 1, 1, 0)

m = m * r

clock = TimerClock.new ticks_per_beat: 4, bpm: 90
sequencer = Sequencer.new 4, 4

sequencer.logger.info!

probe = Probe3D.new(5, logger: sequencer.logger)

probe.render_matrix(m, color: 0xa0a0a0)

quantized_timed_series =
    m.to_p(time_dimension: 2, keep_time: true).collect do |line|
      TIMED_UNION(
          *line.to_timed_serie(time_start_component: 2, base_duration: 1)
               .flatten_timed
               .split
               .tap { |_| _.delete_at(2) } # we don't want time dimension itself to be quantized
               .collect { |_| _.quantize(predictive: true, stops: false) } )
    end

midi_quantized_timed_series =
    quantized_timed_series.collect do |line|
      TIMED_UNION(
          *line.flatten_timed # TimedSerie
               .split
               .collect { |_|
                 _.anticipate { |c, n|
                   n ? c.clone.tap { |_| _[:next_value] = (c[:value] == n[:value]) ? nil : n[:value] } :
                       c } } )
    end

score_quantized_timed_series =
    quantized_timed_series.collect do |line|
      TIMED_UNION(
          *line.flatten_timed # TimedSerie
               .split
               .collect { |_|
                 _.anticipate { |c, n|
                   n ? c.clone.tap { |_| _[:next_value] = (c[:value] == n[:value]) ? nil : n[:value] } :
                       c } } )
    end

puts "midi_quantized_timed_series.size #{midi_quantized_timed_series.size}"

midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[0]

violin_midi_voices = MIDIVoices.new(sequencer: sequencer, output: midi_output, channels: 0..7)
cello_midi_voices = MIDIVoices.new(sequencer: sequencer, output: midi_output, channels: 8..15)

violin = Violin.new('violin', midi_voices: violin_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: sequencer.logger)
cello = Violin.new('cello', midi_voices: cello_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: sequencer.logger)


chromatic_scale = Scales.default_system.default_tuning.chromatic[0]

score = Score.new

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
                 velocity: (coordinates[i][1] / 6r).to_i - 3, # 90 + 5*coordinates[i][1],
                 legato: true,
                 voice: i }.extend(GDV)

        violin.note **note.to_pdv(chromatic_scale)
      end

      if values[1]
        note = { grade: (48 + values[1]).to_i,
                 duration: quantized_duration[1],
                 velocity: (coordinates[i][0] / 6r).to_i - 3, # 90 + 5*coordinates[i][0],
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
probe.run
clock.stop

renderer = RenderMusicXML.new

renderer.render_score(4, 4, score)