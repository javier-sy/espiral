require_relative 'helper'

using Musa::Extension::InspectNice

class Instrument
  include Helper

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

    @pitch_range ||= 0..127 # default pitch range is all midi pitches
    @central_pitch_range ||= @pitch_range # if no central pitch range is defined all the range is considered as central

    @harmonics_pitch_range ||= nil # if no harmonics are defined nil is used

    cache_techniques
  end

  attr_reader :pitch_range
  attr_reader :central_pitch_range

  def techniques # returns canonic symbol id
    @technique_ids
  end

  def technique(id) # returns the information for the technique
    @techniques_cache[id]
  end

  def find_techniques(path) # returns a list of symbol id for techniques that match the path
    root = @techniques_cache.dig(*path)
    found = get_techniques(root)
    found.flatten.uniq
  end

  def note(pitch_note = nil, pitch: nil, voice:, duration:, velocity:, **techniques)
    pitch ||= pitch_note
    techniques = techniques.select { |_, v| v }

    technique, effective_duration, effective_velocity = calculate_technique(duration, velocity, normalize(techniques))

    @voice_to_midi_voice_map.cleanup
    midi_voice = @voice_to_midi_voice_map[voice]

    if !midi_voice
      midi_voice = @midi_voices.find { |voice| voice.active_pitches.all? { |_| _[:note_controls].empty? } }
    end

    if midi_voice
      @voice_to_midi_voice_map[voice] = midi_voice
      voice_info = "channel #{midi_voice.channel}"
      logger_method = :info
    else
      voice_info = "losing notes: not enough voices (#{@midi_voices.size} available)!!!"
      logger_method = :warn
    end

    harmonic = techniques.keys.any? { |t| t.match?('harmonic') }

    unless !harmonic && @pitch_range.include?(pitch) ||
      harmonic && @harmonics_pitch_range&.include?(pitch)

      voice_info += " pitch outside instrument range (#{harmonic ? 'for harmonics ' : ''}#{harmonic ? @harmonics_pitch_range : @pitch_range})!!!"
      logger_method = :warn
    end

    @logger.send(logger_method,
                "#{@name}: "\
                "voice #{voice} "\
                "pitch #{pitch} "\
                "duration #{effective_duration.to_r.inspect} "\
                "velocity #{effective_velocity.to_f.round(0)} "\
                "#{techniques.inspect} "\
                "#{voice_info}")

    midi_voice.note technique.key_switch, duration: @tick_duration if technique
    midi_voice.note pitch, duration: effective_duration, velocity: effective_velocity if midi_voice
  end

  protected def calculate_technique(duration, velocity, techniques)
    @logger.warn { "#{@name}: calculating technique: losing techniques except first one #{techniques}!!!" } if techniques.size > 1
    return technique(techniques&.keys&.first), duration, velocity
  end

  private def normalize(techniques)
    techniques.transform_keys { |t| @techniques_cache[t].technique }
  end

  private def get_techniques(hash)
    hash.values.collect do |element|
      case element
      when Hash
        get_techniques(element)
      else
        element.technique
      end
    end
  end

  private def cache_techniques
    @techniques_cache = {}
    @technique_ids = []
    @techniques.each do |technique_ids, raw_info|
      canonic = nil

      technique_ids.each do |technique|
        case technique
        when Symbol
          if !canonic
            canonic = technique
            info = parse_info(canonic, raw_info)

            @techniques_cache[canonic] = info
            @technique_ids << canonic
          else
            @techniques_cache[technique] = @techniques_cache[canonic]
            @technique_ids << technique
          end

        when Array
          last_step = @techniques_cache
          technique[..-2].each do |path_step|
            case last_step[path_step]
            when nil
              last_step = last_step[path_step] ||= {}
            when TechniqueInfo
              ti = last_step[path_step]
              last_step = last_step[path_step] = { default: ti }
            when Hash
              last_step = last_step[path_step]
            end
          end
          last_step[technique.last] = @techniques_cache[canonic]
        end
      end
    end
  end

  private def parse_info(technique, element)
    case element
    when Numeric
      TechniqueInfo.new(technique: technique, key_switch: element, modulators: [])
    when Hash
      TechniqueInfo.new(technique: technique, **element)
    end
  end

  TechniqueInfo = Struct.new(:technique, :key_switch, :modulators, keyword_init: true)

  private_constant :TechniqueInfo
end
