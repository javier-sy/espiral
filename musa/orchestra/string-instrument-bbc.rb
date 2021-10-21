require 'musa-dsl'

require_relative '../lib/instrument'

using Musa::Extension::InspectNice

class StringInstrument_BBC < Instrument
  def initialize(techniques_set, name, midi_voices:, tick_duration:, logger:)
    leader = (techniques_set == :leader)
    section = (techniques_set == :section)

    @techniques_groups = {
      percussive: [:collegno, :pizzicato, :pizzicato_bartok],
      short: [:short_hrm, :spiccato, :staccato, (:short_marcato if leader), (:spiccato_cs if section)].compact,
      long: [:long_hrm, :long_cs, :long_flt, :long_slt, (:long_slp if section), :legato,
             (:long_marcato if section),
             (:tremolo_cs if section), (:tremolo_slp if section), :tremolo].compact,
      long_multi_note: [:trill_2m, :trill_2M] }

    @techniques = {
      [:short_hrm, :hrm_s, [:short, :harmonics]] => 14,
      [:collegno, :cl, [:short, :collegno]] => 7,
      [:spiccato, :sp, [:short, :spiccato]] => 4,
      [:staccato, :st, [:short, :staccato]] => 5,
      [:short_marcato, :marcato_s, [:short, :marcato]] => (16 if leader),
      [:spiccato_cs, :spcs, [:sp, :cs], [:short, :spiccato, :consordina]] => (20 if section),
      [:pizzicato, :pz, [:short, :pizzicato]] => 6,
      [:pizzicato_bartok, :pzb, [:short, :pizzicato, :bartok]] => 15,

      [:long_hrm, :hrm, [:long, :harmonics]] => 13,
      [:long_cs, :cs, [:long, :consordina]] => { key_switch: 2, modulators: [:vibrato] },
      [:long_flt, :flt, [:long, :flautando]] => 3,
      [:long_slt, :slt, [:long, :sultasto]] => 12,
      [:long_slp, :slp, [:long, :sulpont]] => (19 if section),
      [:long] => { key_switch: 1, modulators: [:vibrato] },
      [:long_marcato, :marcato, :mt, [:long, :marcato]] => (16 if section),

      [:tremolo_cs, :trcs, [:tr, :cs], [:tremolo, :consordina], [:multi_note, :tremolo, :consordina]] => (18 if section),
      [:tremolo_slp, :trslp, [:tr, :slp], [:tremolo, :sulpont], [:multi_note, :tremolo, :sulpont]] => (17 if section),
      [:tremolo, :tr, [:multi_note, :tremolo]] => 8,

      [:trill_2M, [:multi_note, :trill, :M2], [:trill, :M2]] => 10,
      [:trill_2m, [:multi_note, :trill, :m2], [:trill, :m2]] => 11,

      [:legato, :lg] => { key_switch: 0, modulators: [:vibrato] },

    }.delete_if { |_, v| v.nil? }

    super(name, midi_voices: midi_voices, tick_duration: tick_duration, logger: logger)
  end

end

class LeaderStringInstrument_BBC < StringInstrument_BBC
  def initialize(...)
    super(:leader, ...)
  end
end

class SectionStringInstrument_BBC < StringInstrument_BBC
  def initialize(...)
    super(:section, ...)
  end
end
