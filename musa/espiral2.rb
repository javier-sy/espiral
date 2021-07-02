require 'musa-dsl'
require 'unimidi'

require_relative 'string-instruments-bbc'

include Musa::Scales
include Musa::Series
include Musa::Datasets
include Musa::Clock
include Musa::Sequencer
include Musa::MIDIVoices

#
# Sequencer and logging setup
#

clock = TimerClock.new ticks_per_beat: 4, bpm: 90

sequencer = Sequencer.new 4, 4
sequencer.logger.info!

logger = sequencer.logger.clone
logger.info!

#
#
# MIDI rendering
#

midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[0]

violin_midi_voices = MIDIVoices.new(sequencer: sequencer, output: midi_output, channels: 0..7, do_log: true)
cello_midi_voices = MIDIVoices.new(sequencer: sequencer, output: midi_output, channels: 8..15)

violin = Violin.new('violin',
                    midi_voices: violin_midi_voices.voices,
                    tick_duration: sequencer.tick_duration,
                    logger: logger)

cello = Cello.new('cello',
                  midi_voices: cello_midi_voices.voices,
                  tick_duration: sequencer.tick_duration,
                  logger: logger)

chromatic_scale = Scales.default_system.default_tuning.chromatic[0]

control = nil

sequencer.at 1 do
  control = every 1 do
    note = { grade: 84,
             duration: 1/8r,
             velocity: 0.5,
             legato: true,
             voice: 1 }.extend(GDV)

    violin.note **note.to_pdv(chromatic_scale)
  end
end

Thread.new { clock.run { sequencer.tick } }

sleep 0.2
clock.start

sleep 5
control.stop

clock.stop

