require_relative 'instrument'

class Instrument_BBC < Instrument
  @@MIC_CC = {
    tree: 25, outriggers: 26, sides: 34,
    leader: 29, close: 24,
    atmos_front: 41,
    mono: 28,
    stereo_section: 31, mids: 33, close_wide: 30,
    ambient: 27, balcony: 35, atmos_rear: 42,
    full_spill: 40, strings_spill: 36, woodwinds_spill: 37, brass_spill: 38, percussion_spill: 39,
    mix1: 22, mix2: 23
  }.freeze

  @@DEFAULT_MIC_LEVELS = { mix2: 127 }.freeze

  def initialize(name, midi_voices:, tick_duration:, logger:)
    super

    @@MIC_CC.each_key do |mic|
      set_mic_level(mic, @@DEFAULT_MIC_LEVELS[mic] || 0)
    end
  end

  def set_mic_level(mic, level)
    @midi_voices.each do |midi_voice|
      if midi_voice.controller[@@MIC_CC[mic]].nil?

        midi_voice.controller[@@MIC_CC[mic]] = 1
        sleep(0.01)
      end
      midi_voice.controller[@@MIC_CC[mic]] = level
    end
  end
end
