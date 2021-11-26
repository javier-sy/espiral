require_relative 'instrument-helper'

using Musa::Extension::InspectNice

class Instrument
  include InstrumentHelper

  def initialize(name, midi_voices:, tick_duration:, logger:)
    @name = name || self.class.name
    @midi_voices = midi_voices
    @tick_duration = tick_duration
    @logger = logger
    @played_notes_count = 0

    @voice_to_midi_voice_map = {}

    def @voice_to_midi_voice_map.cleanup
      delete_if do |_, midi_voice|
        midi_voice.active_pitches.all? { |_| _[:note_controls].empty? }
      end
    end

    @pitch_range ||= 0..127 # default pitch range is all midi pitches
    @central_pitch_range ||= @pitch_range # if no central pitch range is defined all the range is considered as central

    @harmonics_pitch_range ||= nil # if no harmonics are defined nil is used
    @polyphony ||= 1 # by default only one note simultaneously

    cache_techniques
  end

  attr_reader :name

  attr_reader :pitch_range
  attr_reader :harmonics_pitch_range
  attr_reader :central_pitch_range

  attr_reader :polyphony

  attr_reader :techniques_groups

  attr_reader :played_notes_count

  def techniques # returns canonic symbol id
    @technique_ids
  end

  def technique(id) # returns the information for the technique
    @techniques_cache[id]
  end

  def find_techniques(*path) # returns a list of techniques that match the path
    root = @techniques_cache.dig(*path)
    found = get_techniques(root)
    found.flatten.uniq
  end

  def free_voices
    @midi_voices.collect { |midi_voice| @polyphony - midi_voice.active_pitches.count { |_| !_[:note_controls].empty? } }.sum
  end

  def note(pitch_note = nil, pitch: nil, voice:, duration:, velocity:, **techniques)
    pitch ||= pitch_note
    techniques = techniques.select { |_, v| v }

    technique, effective_duration, effective_velocity = calculate_technique(pitch, duration, velocity, normalize(techniques))

    @voice_to_midi_voice_map.cleanup
    midi_voice = @voice_to_midi_voice_map[voice]

    if !midi_voice || midi_voice.active_pitches.count { |_| !_[:note_controls].empty? } >= @polyphony
      midi_voice = @midi_voices.find { |midi_voice| midi_voice.active_pitches.count { |_| !_[:note_controls].empty? } < @polyphony }
    end

    # TODO cuando una misma midi_voice con polifonía recibe techniques diferentes para diferentes voices surge un conflicto. hay que controlarlo?

    if midi_voice
      @voice_to_midi_voice_map[voice] = midi_voice
      voice_info = "channel #{midi_voice.channel}"
      logger_method = :info
    else
      voice_info = "losing notes: not enough voices with note slots available (used #{@midi_voices.size} voices with #{@polyphony} notes of polyphony each)!!!"
      logger_method = :warn
    end

    harmonic = techniques.keys.any? { |t| t.match?('harmonic') }

    unless !harmonic && @pitch_range.include?(pitch) ||
      harmonic && @harmonics_pitch_range&.include?(pitch)

      voice_info += " pitch outside instrument range (#{harmonic ? 'for harmonics ' : ''}#{harmonic ? @harmonics_pitch_range : @pitch_range})!!!"
      logger_method = :warn
    end

    @played_notes_count += 1
    @logger.send(logger_method,
                "#{@name}: "\
                "voice #{voice} "\
                "pitch #{pitch} "\
                "duration #{effective_duration.to_r.inspect} "\
                "velocity #{effective_velocity.to_f.round(0)} "\
                "#{techniques.inspect} "\
                "#{voice_info}")

    midi_voice.note technique.key_switch, duration: @tick_duration if technique&.key_switch > -1

    if midi_voice
      if (technique.tags === :long || technique.tags === :legato) && @polyphony == 1
        midi_voice.controller[:mod_wheel] = effective_velocity
        midi_voice.controller[:expression] = effective_velocity
      else
        midi_voice.controller[:mod_wheel] = midi_voice.controller[:expression] = 127
      end

      midi_voice.note pitch, duration: effective_duration, velocity: effective_velocity
    end
  end

  protected def calculate_technique(pitch, duration, velocity, techniques)
    @logger.warn { "#{@name}: calculating technique: losing techniques except first one #{techniques}!!!" } if techniques.size > 1
    technique = technique(techniques&.keys&.first)

    effective_duration = 1/4r if technique.tags.include?(:short)
    effective_duration ||= duration

    effective_velocity = 64 + velocity / 2 if technique.tags.include?(:short)
    effective_velocity ||= velocity

    return technique, effective_duration, effective_velocity
  end

  private def normalize(techniques)
    techniques&.transform_keys { |t| @techniques_cache[t].id }
  end

  private def get_techniques(thing)
    case thing
    when Symbol
      raise "NO SE QUE HACER AQUI"
    when Hash
      thing.values.collect do |element|
        get_techniques(element)
      end
    else
      [thing]
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
            info = parse_info(canonic, technique_ids, raw_info)

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

  private def parse_info(technique_id, technique_ids, element)
    tags = Set[*technique_ids.flatten.uniq]

    case element
    when Numeric
      TechniqueInfo.new(id: technique_id, key_switch: element, tags: tags, modulators: [])
    when Hash
      TechniqueInfo.new(id: technique_id, tags: tags, **element)
    end
  end

  TechniqueInfo = Struct.new(:id, :key_switch, :modulators, :tags, keyword_init: true)

  private_constant :TechniqueInfo
end
