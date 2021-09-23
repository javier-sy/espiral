require_relative 'composition-base'

require_relative 'string-instruments-bbc'
require_relative 'ww-instruments-bbc'
require_relative 'brass-instruments-bbc'
require_relative 'tuned-percussions-bbc'
require_relative 'keyboard-instruments-pianoteq'

require_relative 'instruments-pool'

class CompositionWithInstrumentation < CompositionBase
  def initialize(real_clock: false, do_voices_log: true)
    super

    # Create instruments
    #
    create_instruments

    # Separate instruments regarding mostly harmonic content vs less-harmonic content
    # Making a pool of each category
    #
    harmonic_timbres, percussive_timbres = select_harmonic_timbres

    @harmonic_instruments = InstrumentsPool.new(*harmonic_timbres)
    @percussive_instruments = InstrumentsPool.new(*percussive_timbres)

    @all_instruments = InstrumentsPool.new(*(harmonic_timbres + percussive_timbres))
  end

  private def create_instruments
    # MIDI rendering setup
    #
    violins_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[1]
    strings_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[2]
    ww_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[3]
    brass_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[4]
    tuned_perc_midi_output = UniMIDI::Output.all.select { |x| /Driver IAC/ =~ x.name }[5]

    # Strings definition
    #
    violin_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: violins_midi_output, channels: 1..8, do_log: @do_voices_log)
    viola_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: strings_midi_output, channels: 1..4, do_log: @do_voices_log)
    cello_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: strings_midi_output, channels: 5..8, do_log: @do_voices_log)
    contrabass_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: strings_midi_output, channels: 9..12, do_log: @do_voices_log)

    @violin = Violin.new(midi_voices: violin_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @viola = Viola.new(midi_voices: viola_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @cello = Cello.new(midi_voices: cello_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @contrabass = Contrabass.new(midi_voices: contrabass_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)

    # Woodwinds definition
    #
    piccolo_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: ww_midi_output, channels: 1, do_log: @do_voices_log)
    flute_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: ww_midi_output, channels: 2, do_log: @do_voices_log)
    clarinet_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: ww_midi_output, channels: 3..4, do_log: @do_voices_log)
    bass_clarinet_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: ww_midi_output, channels: 5, do_log: @do_voices_log)
    oboe_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: ww_midi_output, channels: 6..7, do_log: @do_voices_log)
    bassoon_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: ww_midi_output, channels: 8, do_log: @do_voices_log)
    cor_anglais_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: ww_midi_output, channels: 9, do_log: @do_voices_log)

    @piccolo = Piccolo.new(midi_voices: piccolo_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @flute = Flute.new(midi_voices: flute_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @clarinet = Clarinet.new(midi_voices: clarinet_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @bass_clarinet = BassClarinet.new(midi_voices: bass_clarinet_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @oboe = Oboe.new(midi_voices: oboe_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @bassoon = Bassoon.new(midi_voices: bassoon_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @cor_anglais = CorAnglais.new(midi_voices: cor_anglais_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)

    # Brass definition
    #
    french_horn_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: brass_midi_output, channels: 1..4, do_log: @do_voices_log)
    trombone_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: brass_midi_output, channels: 5..6, do_log: @do_voices_log)
    contrabass_trombone_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: brass_midi_output, channels: 7, do_log: @do_voices_log)
    tuba_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: brass_midi_output, channels: 8, do_log: @do_voices_log)
    trumpet_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: brass_midi_output, channels: 9, do_log: @do_voices_log)

    @french_horn = FrenchHorn.new(midi_voices: french_horn_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @trombone = TenorTrombone.new(midi_voices: trombone_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @contrabass_trombone = ContrabassTrombone.new(midi_voices: contrabass_trombone_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @tuba = Tuba.new(midi_voices: tuba_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @trumpet = Trumpet.new(midi_voices: trumpet_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)

    # Tuned percussion
    #
    tubular_bells_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: tuned_perc_midi_output, channels: 1, do_log: @do_voices_log)
    marimba_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: tuned_perc_midi_output, channels: 2, do_log: @do_voices_log)
    glockenspiel_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: tuned_perc_midi_output, channels: 3, do_log: @do_voices_log)
    vibraphone_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: tuned_perc_midi_output, channels: 4, do_log: @do_voices_log)

    @tubular_bells = TubularBells.new(midi_voices: tubular_bells_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @marimba = Marimba.new(midi_voices: marimba_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @glockenspiel = Glockenspiel.new(midi_voices: glockenspiel_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
    @vibraphone = Vibraphone.new(midi_voices: vibraphone_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)

    # Blanchet Harpsichord
    #
    harpshichord_midi_voices = MIDIVoices.new(sequencer: @sequencer, output: tuned_perc_midi_output, channels: 5, do_log: @do_voices_log)

    @harpsichord = FEBlanchetHarpsichord.new(midi_voices: harpshichord_midi_voices.voices, tick_duration: @sequencer.tick_duration, logger: @logger)
  end

  private def select_harmonic_timbres
    #
    # Timbre scale for mostly harmonic instruments (sorted by incremental internal consonance)
    # Source: personal investigation ("doc/Análisis espectral")
    #

    harmonic_timbres = [
      @bass_clarinet,
      @french_horn,
      @contrabass,
      @oboe,
      @flute,
      @violin,
      @viola,
      @cello,
      @contrabass_trombone,
      @piccolo,
      @trumpet,
      @cor_anglais,
      @bassoon,
      @trombone,
      @tuba,
      @clarinet]

    # Timbre scale for non-harmonic instruments (without order)
    #
    percussive_timbres = [@marimba, @vibraphone, @tubular_bells, @glockenspiel]

    # Harpshichord is used only on level2, so it's excluded here

    [harmonic_timbres, percussive_timbres]
  end

end
