using Musa::Extension::InspectNice

class Violin
  def initialize(name, midi_voices:, tick_duration:, logger:)
    @name = name
    @midi_voices = midi_voices
    @tick_duration = tick_duration
    @logger = logger

    @voice_to_midi_voice_map = {}

    def @voice_to_midi_voice_map.cleanup
      delete_if do |_, midi_voice|
        midi_voice.active_pitches.all? { |_| _[:note_controls].empty? }
      end
    end
  end

  def note(pitch_note = nil, pitch: nil, voice:, duration:, velocity:, **articulation)

    pitch ||= pitch_note

    @logger.info { "#{@name}: note #{pitch} duration #{duration} velocity #{velocity}" }

    staccato = articulation[:staccato] || articulation[:st]
    standard = articulation[:standard]
    legato = articulation[:legato] || articulation[:lg]
    accent = articulation[:accent] || articulation[:ac]

    counter = 0

    counter += 1 if staccato
    counter += 1 if standard
    counter += 1 if legato

    raise ArgumentError, "Cannot use more than one articulation at the same time" if counter > 1

    staccato = 1 if staccato == true
    standard = 1 if standard == true
    legato = 1 if legato == true
    accent = 1 if accent == true

    standard = 1r if counter == 0

    if staccato
      effective_duration = (@tick_duration * 8r) / (2 ** staccato.to_r)
    end

    if legato
      effective_duration = duration + @tick_duration * (2 ** legato.to_r)
    end

    if standard
      effective_duration = duration * (2 ** standard.to_r / (2 ** standard.to_r + 1))
    end

    if accent
      effective_velocity = velocity + (127 - velocity) * accent.to_r
    else
      effective_velocity = velocity
    end

    effective_velocity = 127 if effective_velocity > 127
    effective_velocity = 0 if effective_velocity < 0

    @voice_to_midi_voice_map.cleanup
    midi_voice = @voice_to_midi_voice_map[voice]

    if !midi_voice
      midi_voice = @midi_voices.find { |voice| voice.active_pitches.all? { |_| _[:note_controls].empty? } }
    end

    if midi_voice
      @voice_to_midi_voice_map[voice] = midi_voice
      voice_info = "channel #{midi_voice.channel}"
    else
      voice_info = "losing notes: not enough voices!!!"
    end

    @logger.info do
      "#{@name}: "\
      "voice #{voice} "\
      "pitch #{pitch} "\
      "duration #{effective_duration.to_r.inspect} "\
      "velocity #{effective_velocity.to_f.round(0)} "\
      "#{articulation.inspect} "\
      "#{voice_info}"
    end

    midi_voice.note pitch, duration: effective_duration, velocity: effective_velocity if midi_voice
  end

end
