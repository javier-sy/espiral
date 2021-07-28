require 'musa-dsl'
require 'unimidi'

require_relative 'string-instruments-bbc'
require_relative 'ww-instruments-bbc'
require_relative 'brass-instruments-bbc'
require_relative 'tuned-percussions-bbc'
require_relative 'keyboard-instruments-pianoteq'

require_relative 'probe-3d'
require_relative 'matrix-operations'

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

clock = TimerClock.new ticks_per_beat: 4, bpm: 90

sequencer = Sequencer.new 4, 4

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

matrix = MatrixOperations.spiral(1000)

# Rotate matrix
#
# r = MatrixOperations.rotation(0.45, 1, 1, 0)
# r = MatrixOperations.rotation(0.35, 0.5, 1, 0.3)
# r = MatrixOperations.rotation(0.25, 0.1, 1, 0.1) # interesante
transformation = MatrixOperations.rotation(Math::PI/3, 0, 1, 0) # interesante
# r = MatrixOperations.rotation(Math::PI/3, 0, 1, 0)

matrix = matrix * transformation

#
# Source quantization for MIDI
#

p_array = matrix.to_p(time_dimension: 2, keep_time: true)

midi_quantized_timed_series_array =
  p_array.collect do |p|
    TIMED_UNION(
      *p.to_timed_serie(time_start_component: 2, base_duration: 1)
           .flatten_timed
           .split.instance
           .to_a
           .tap { |_| _.delete_at(2) } # we don't want time dimension itself to be quantized
           .collect { |_|
             _.quantize(predictive: true, stops: false)
              .anticipate { |_, c, n|
                n ? c.clone.tap { |_| _[:next_value] = (c[:value].nil? || c[:value] == n[:value]) ? nil : n[:value] } :
                  c } }
    )
  end

#
# Chromatic scale setup
#

chromatic_scale = Scales.default_system.default_tuning.chromatic[0]

#
# 3D rendering setup and base drawing
#

probe = Probe3D.new(10, logger: logger)

probe.render_matrix(matrix, color: 0xa0a0a0)

#
# Rendering to midi
#

def put_in_pitch_range(instrument, pitch)
  if instrument.pitch_range.include?(pitch)
    new_pitch = pitch
  else
    new_pitch = (pitch % (instrument.pitch_range.max - instrument.pitch_range.min)) + instrument.pitch_range.min
    logger.warn "pitch #{pitch} no está incluido en el rango para #{instrument.name}... generando nota #{new_pitch}"
  end

  new_pitch
end

Thread.new do
  coordinates = []

  sequencer.at 1 do
    midi_quantized_timed_series_array.each_with_index do |quantized_timed_serie, i|
      sequencer.play_timed quantized_timed_serie do |values, duration:|

        quantized_duration =
          duration.collect { |d| sequencer.quantize_position(sequencer.position + d) - sequencer.position if d }

        coordinates[i] = [values[0] || coordinates[i][0],
                          values[1] || coordinates[i][1],
                          sequencer.position - 1r]

        probe.render_point(i, coordinates[i], color: 0x0fffff)

        puts "values = #{values}"
        if values[0]
          # interpretamos los valores como [pitch/velocity, velocity/pitch, time]

          note = { grade: (84 + values[0]).to_i,
                   duration: quantized_duration[0],
                   velocity: (coordinates[i][1] / 6r).to_i - 3,
                   voice: i }.extend(GDV)

          instrument = pool.find_free

          technique = instrument.find_techniques(:legato).first
          technique ||= instrument.find_techniques(:long).first
          technique ||= instrument.find_techniques(:short).first

          raise "Cannot find a technique for #{instrument.name}!!!!" unless technique

          note[technique.id] = true

          instrument.note **note.to_pdv(chromatic_scale).tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }
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


# control = nil
#
# instruments = all_timbres.clone
#
# sequencer.at 1 do
#   control = every 1/4r do
#     instrument = instruments.shift
#
#     if instrument
#       note = { grade: 84,
#                duration: 1r,
#                velocity: 0.90,
#                voice: 1 }.extend(GDV)
#
#       technique = instrument.find_techniques(:legato).first
#       technique ||= instrument.find_techniques(:long).first
#       technique ||= instrument.find_techniques(:short).first
#
#       raise "Cannot find a technique for #{instrument.name}!!!!" unless technique
#
#       note[technique.id] = true
#
#       instrument.note **note.to_pdv(chromatic_scale).tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }
#     else
#       control.stop
#     end
#   end
# end
#
#
# Thread.new { clock.run { sequencer.tick } }
#
# sleep 0.2
# clock.start
#
# sleep 1
#
# until sequencer.empty?
#   sleep 1
# end
#
# clock.stop

