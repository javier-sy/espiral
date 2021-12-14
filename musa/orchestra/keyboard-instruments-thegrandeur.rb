require 'musa-dsl'

require_relative 'keyboard-instrument'

class TheGrandeurPiano < Piano
  def initialize(name = nil, midi_voices:, tick_duration:, logger:)
    @pitch_range = pitch('c-1')..pitch('c7')
    @polyphony = 3
    super
  end


  def note(pitch_note = nil, pitch: nil, voice:, duration:, bpm:, velocity:, level2: nil, level3: nil, **techniques)
    pitch_to_play = pitch || pitch_note

    if pitch_to_play == @last_pitch_played && velocity == @last_velocity_played && techniques == @last_techniques_played
      @logger.info "Piano: repeating note #{pitch_to_play} with #{techniques}"
    end

    super

    @last_pitch_played = pitch_to_play
    @last_velocity_played = velocity
    @last_techniques_played = techniques
  end
end
