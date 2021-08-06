require 'musa-dsl'
require 'unimidi'

require_relative 'string-instruments-bbc'
require_relative 'ww-instruments-bbc'
require_relative 'brass-instruments-bbc'
require_relative 'tuned-percussions-bbc'
require_relative 'keyboard-instruments-pianoteq'

require_relative 'probe-3d'
require_relative 'matrix-operations'
require_relative 'helper'

require_relative 'instruments-pool'

include Musa::MIDIVoices
include Musa::Clock
include Musa::Sequencer
include Musa::Scales
include Musa::Series
include Musa::Datasets

using Musa::Extension::Matrix
using Musa::Extension::InspectNice

#
# Sequencer setup
#

sequencer = Sequencer.new 4, 4
# clock = TimerClock.new ticks_per_beat: 4, bpm: 90
clock = DummyClock.new { !sequencer.empty? }

#
# Logging setup
#

sequencer.logger.error!

logger = sequencer.logger.clone
logger.info!

do_voices_log = true

#
# MIDI rendering setup
#

violins_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[1]
strings_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[2]
ww_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[3]
brass_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[4]
tuned_perc_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[5]

#
# Strings definition
#

violin_midi_voices = MIDIVoices.new(sequencer: sequencer, output: violins_midi_output, channels: 1..8, do_log: do_voices_log)
viola_midi_voices = MIDIVoices.new(sequencer: sequencer, output: strings_midi_output, channels: 1..4, do_log: do_voices_log)
cello_midi_voices = MIDIVoices.new(sequencer: sequencer, output: strings_midi_output, channels: 5..8, do_log: do_voices_log)
contrabass_midi_voices = MIDIVoices.new(sequencer: sequencer, output: strings_midi_output, channels: 9..12, do_log: do_voices_log)

violin = Violin.new(midi_voices: violin_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
viola = Viola.new(midi_voices: viola_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
cello = Cello.new(midi_voices: cello_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
contrabass = Contrabass.new(midi_voices: contrabass_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

#
# Woodwinds definition
#

piccolo_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 1, do_log: do_voices_log)
flute_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 2, do_log: do_voices_log)
clarinet_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 3..4, do_log: do_voices_log)
bass_clarinet_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 5, do_log: do_voices_log)
oboe_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 6..7, do_log: do_voices_log)
bassoon_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 8, do_log: do_voices_log)
cor_anglais_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 9, do_log: do_voices_log)

piccolo = Piccolo.new(midi_voices: piccolo_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
flute = Flute.new(midi_voices: flute_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
clarinet = Clarinet.new(midi_voices: clarinet_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
bass_clarinet = BassClarinet.new(midi_voices: bass_clarinet_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
oboe = Oboe.new(midi_voices: oboe_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
bassoon = Bassoon.new(midi_voices: bassoon_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
cor_anglais = CorAnglais.new(midi_voices: cor_anglais_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

#
# Brass definition
#

french_horn_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 1..4, do_log: do_voices_log)
trombone_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 5..6, do_log: do_voices_log)
contrabass_trombone_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 7, do_log: do_voices_log)
tuba_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 8, do_log: do_voices_log)
trumpet_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 9, do_log: do_voices_log)

french_horn = FrenchHorn.new(midi_voices: french_horn_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
trombone = TenorTrombone.new(midi_voices: trombone_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
contrabass_trombone = ContrabassTrombone.new(midi_voices: contrabass_trombone_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
tuba = Tuba.new(midi_voices: tuba_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
trumpet = Trumpet.new(midi_voices: trumpet_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

#
# Tuned percussion
#

tubular_bells_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 1, do_log: do_voices_log)
marimba_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 2, do_log: do_voices_log)
glockenspiel_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 3, do_log: do_voices_log)
vibraphone_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 4, do_log: do_voices_log)

tubular_bells = TubularBells.new(midi_voices: tubular_bells_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
marimba = Marimba.new(midi_voices: marimba_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
glockenspiel = Glockenspiel.new(midi_voices: glockenspiel_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
vibraphone = Vibraphone.new(midi_voices: vibraphone_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

#
# Blanchet Harpsichord
#

harpshichord_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 5, do_log: do_voices_log)

harpsichord = FEBlanchetHarpsichord.new(midi_voices: harpshichord_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

#
# Timbre scale for mostly harmonic instruments (sorted by incremental internal consonance)
# Source: personal investigation ("doc/Análisis espectral")
#

harmonic_timbres = [
  bass_clarinet,
  french_horn,
  contrabass,
  oboe,
  flute,
  violin,
  viola,
  cello,
  contrabass_trombone,
  piccolo,
  trumpet,
  cor_anglais,
  bassoon,
  harpsichord,
  trombone,
  tuba,
  clarinet]

#
# Timbre scale for non-harmonic instruments (without order)
#

non_harmonic_timbres = [marimba, vibraphone, tubular_bells, glockenspiel]

all_timbres = harmonic_timbres + non_harmonic_timbres

pool = InstrumentsPool.new(*all_timbres)

#
# Compute spiral 3D matrix
#

phi = 1.6180339887499

turns = 24
bars_per_turn = 32
length = turns * bars_per_turn

phi_turns = (turns / phi).round
phi_length = length / phi

puts "turns = #{turns}"
puts "bars_per_turn = #{bars_per_turn}"
puts "length = #{length}"
puts "phi_turns = #{phi_turns}"
puts "phi_length = #{phi_length}"

matrix1a = MatrixOperations.spiral(phi_turns, length: phi_length, radius_end: 10, resolution: 720)
matrix1b = MatrixOperations.spiral(turns - phi_turns, z_start: phi_length, length: (length - phi_length), radius_start: 10, resolution: 720)
matrix1 = matrix1a.vstack(matrix1b)

#
# Source quantization for MIDI
#

matrix1_p_array = matrix1.to_p(time_dimension: 2, keep_time: true)

matrix1_quantized_timed_series_array = quantized_timed_series_of_p_array(matrix1_p_array, quantization_step: 0.5)

# midi_quantized_timed_series_array has only 1 element because the spiral has no time folding
#
matrix1_quantized_timed_series = matrix1_quantized_timed_series_array.first

#
# 3D rendering setup and base drawing
#

probe = Probe3D.new(100, z_scale: 0.1, logger: logger)

probe.render_matrix(matrix1, color: 0xa0a0a0)

#
# Engines on...
#

Thread.new do
  sequencer.at 1 do

    turns = 0
    every_turn = sequencer.every bars_per_turn do
      logger.info "turn #{turns}"
      turns += 1
    end

    coordinates = [nil] * 3
    play_matrix1 = sequencer.play_timed matrix1_quantized_timed_series do |values, duration:|
      2.times { |i| coordinates[i] = values[i] if values[i] }
      coordinates[2] = sequencer.position - 1r

      # logger.info "rendering #{coordinates}"
      probe.render_point('first level', coordinates, color: 0x0fffff)
    end

    play_matrix1.after do
      logger.info "stopping"
      every_turn.stop
    end

  end

  Thread.new { clock.run { sequencer.tick } }

  sleep 0.1
  begin
    clock.start
  rescue NoMethodError => e
    puts "Ignoring #{e.message}"
  end
end

probe.run
begin
  clock.stop
rescue NoMethodError => e
  puts "Ignoring #{e.message}"
end


