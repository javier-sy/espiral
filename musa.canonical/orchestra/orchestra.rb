require 'set'
require 'midi-communications'
require 'musa-dsl'

require_relative '../orchestra/string-instruments-bbc'
require_relative '../orchestra/ww-instruments-bbc'
require_relative '../orchestra/brass-instruments-bbc'
require_relative '../orchestra/tuned-percussions-bbc'
require_relative '../orchestra/keyboard-instruments-pianoteq'
require_relative '../orchestra/keyboard-instruments-thegrandeur'

class Orchestra
  include Musa::MIDIVoices

  def initialize(sequencer, logger:, do_voices_log:)
    create_instruments(sequencer, logger, do_voices_log)
    
    @timbres = {
      @bass_clarinet => %i[woodwinds harmonic],
      @french_horn => %i[brass harmonic],
      @contrabass => %i[strings harmonic],
      @oboe => %i[woodwinds harmonic],
      @flute => %i[woodwinds harmonic],
      @violin => %i[strings harmonic],
      @viola => %i[strings harmonic],
      @cello => %i[strings harmonic],
      @contrabass_trombone => %i[brass harmonic],
      @piccolo => %i[woodwinds harmonic],
      @trumpet => %i[brass harmonic],
      @cor_anglais => %i[woodwinds harmonic],
      @bassoon => %i[woodwinds harmonic],
      @trombone => %i[brass harmonic],
      @tuba => %i[brass harmonic],
      @clarinet => %i[woodwinds harmonic],
      @marimba => %i[percussion nonharmonic],
      @vibraphone => %i[percussion nonharmonic],
      @tubular_bells => %i[percussion nonharmonic],
      @glockenspiel => %i[percussion nonharmonic]
    }

    @instrument_by_tag = {}
    @timbres.each_pair do |instrument, tags|
      tags.each do |tag|
        @instrument_by_tag[tag] ||= []
        @instrument_by_tag[tag] << instrument
      end
    end

    @instrument_by_tag.each_pair do |tag, instruments|
      min_pitch = instruments.collect(&:pitch_range).collect(&:min).min
      max_pitch = instruments.collect(&:pitch_range).collect(&:max).max

      min_central_pitch = instruments.collect(&:best_pitch_range).collect(&:min).min
      max_central_pitch = instruments.collect(&:best_pitch_range).collect(&:max).max

      min_harmonics_pitch = instruments.collect(&:harmonics_pitch_range).compact.collect(&:min).min
      max_harmonics_pitch = instruments.collect(&:harmonics_pitch_range).compact.collect(&:max).max

      logger.info("Orchestra set #{tag} full range #{min_pitch}-#{max_pitch}, central #{min_central_pitch}-#{max_central_pitch}, harmonics #{min_harmonics_pitch}-#{max_harmonics_pitch}")
    end
  end

  attr_reader :harpsichord, :piano

  private def create_instruments(sequencer, logger, do_voices_log)
    # MIDI rendering setup
    #
    violins_midi_output = MIDICommunications::Output.all.select { |x| x.name == 'Espiral (violins)' }.first
    strings_midi_output = MIDICommunications::Output.all.select { |x| x.name == 'Espiral (other strings)' }.first
    ww_midi_output = MIDICommunications::Output.all.select { |x| x.name == 'Espiral (woodwinds)' }.first
    brass_midi_output = MIDICommunications::Output.all.select { |x| x.name == 'Espiral (brass)' }.first
    tuned_perc_midi_output = MIDICommunications::Output.all.select { |x| x.name == 'Espiral (tuned percussion)' }.first

    # Strings definition
    #
    violin_midi_voices = MIDIVoices.new(sequencer: sequencer, output: violins_midi_output, channels: 0..7, do_log: do_voices_log)
    viola_midi_voices = MIDIVoices.new(sequencer: sequencer, output: strings_midi_output, channels: 0..3, do_log: do_voices_log)
    cello_midi_voices = MIDIVoices.new(sequencer: sequencer, output: strings_midi_output, channels: 4..7, do_log: do_voices_log)
    contrabass_midi_voices = MIDIVoices.new(sequencer: sequencer, output: strings_midi_output, channels: 8..11, do_log: do_voices_log)

    @violin = Violin.new(midi_voices: violin_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @viola = Viola.new(midi_voices: viola_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @cello = Cello.new(midi_voices: cello_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @contrabass = Contrabass.new(midi_voices: contrabass_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

    # Woodwinds definition
    #
    piccolo_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 0, do_log: do_voices_log)
    flute_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 1, do_log: do_voices_log)
    clarinet_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 2..3, do_log: do_voices_log)
    bass_clarinet_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 4, do_log: do_voices_log)
    oboe_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 5..6, do_log: do_voices_log)
    bassoon_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 7, do_log: do_voices_log)
    cor_anglais_midi_voices = MIDIVoices.new(sequencer: sequencer, output: ww_midi_output, channels: 8, do_log: do_voices_log)

    @piccolo = Piccolo.new(midi_voices: piccolo_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @flute = Flute.new(midi_voices: flute_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @clarinet = Clarinet.new(midi_voices: clarinet_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @bass_clarinet = BassClarinet.new(midi_voices: bass_clarinet_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @oboe = Oboe.new(midi_voices: oboe_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @bassoon = Bassoon.new(midi_voices: bassoon_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @cor_anglais = CorAnglais.new(midi_voices: cor_anglais_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

    # Brass definition
    #
    french_horn_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 0..3, do_log: do_voices_log)
    trombone_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 4..5, do_log: do_voices_log)
    contrabass_trombone_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 6, do_log: do_voices_log)
    tuba_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 7, do_log: do_voices_log)
    trumpet_midi_voices = MIDIVoices.new(sequencer: sequencer, output: brass_midi_output, channels: 8, do_log: do_voices_log)

    @french_horn = FrenchHorn.new(midi_voices: french_horn_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @trombone = TenorTrombone.new(midi_voices: trombone_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @contrabass_trombone = ContrabassTrombone.new(midi_voices: contrabass_trombone_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @tuba = Tuba.new(midi_voices: tuba_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @trumpet = Trumpet.new(midi_voices: trumpet_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

    # Tuned percussion
    #
    tubular_bells_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 0, do_log: do_voices_log)
    marimba_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 1, do_log: do_voices_log)
    glockenspiel_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 2, do_log: do_voices_log)
    vibraphone_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 3, do_log: do_voices_log)

    @tubular_bells = TubularBells.new(midi_voices: tubular_bells_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @marimba = Marimba.new(midi_voices: marimba_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @glockenspiel = Glockenspiel.new(midi_voices: glockenspiel_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
    @vibraphone = Vibraphone.new(midi_voices: vibraphone_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

    # Blanchet Harpsichord
    #
    harpshichord_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 4, do_log: do_voices_log)

    @harpsichord = FEBlanchetHarpsichord.new(midi_voices: harpshichord_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)

    # The Grandeur Piano
    #
    piano_midi_voices = MIDIVoices.new(sequencer: sequencer, output: tuned_perc_midi_output, channels: 5, do_log: do_voices_log)

    @piano = TheGrandeurPiano.new(midi_voices: piano_midi_voices.voices, tick_duration: sequencer.tick_duration, logger: logger)
  end

  def select(*tags)
    selected = Set[]

    tags.each do |tag|
      @instrument_by_tag[tag].each do |instrument|
        selected << instrument
      end
    end

    @timbres.collect do |instrument, _|
      instrument if selected.include?(instrument)
    end.compact
  end

  def complete
    @timbres.keys
  end

  def status
    @timbres.keys.collect do |instrument|
      [instrument.name, instrument.played_notes_count]
    end.to_h.merge({ piano: @piano.played_notes_count, harpsichord: @harpsichord.played_notes_count })
  end
end
