require_relative 'espiral-instrumentation-3'

require_relative 'matrix-operations'

using Musa::Extension::Matrix

class EspiralV3 < EspiralInstrumentation3
  include Musa::Scales
  extend Musa::Series
  include Musa::Series
  include Musa::Datasets

  LEVEL2_SPIRALS = 13 # fibonacci serie 1 1 2 3 5 8 _13_ 21 34
  LEVEL2_SPIRALS_BEFORE_INFLECTION = 8

  LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE =
    FIBO().max_size(LEVEL2_SPIRALS_BEFORE_INFLECTION) +
    FIBO().skip(LEVEL2_SPIRALS - LEVEL2_SPIRALS_BEFORE_INFLECTION - 1).max_size(LEVEL2_SPIRALS - LEVEL2_SPIRALS_BEFORE_INFLECTION).reverse

  LEVEL3_BARS_PER_TURN_SERIE =
    (FIBO().max_size(LEVEL2_SPIRALS_BEFORE_INFLECTION).reverse +
      FIBO().max_size(LEVEL2_SPIRALS - LEVEL2_SPIRALS_BEFORE_INFLECTION))
      .map { |_| _ * 2 }

  LEVEL2_BARS_PER_SPIRAL_SERIE = A(LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE, LEVEL3_BARS_PER_TURN_SERIE).map { |turns, bars| turns * bars }

  LEVEL1_TURNS = 21 # fibonacci serie 1 1 2 3 5 8 13 _21_ 34
  LEVEL1_TURNS_BEFORE_INFLECTION = 13
  LEVEL1_BARS_PER_TURN = LEVEL2_BARS_PER_SPIRAL_SERIE.to_a.sum / LEVEL1_TURNS

  puts "CONFIGURATION"
  puts "-------------"
  puts "LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE = #{LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE.to_a}"
  puts "LEVEL3_BARS_PER_TURN_SERIE        = #{LEVEL3_BARS_PER_TURN_SERIE.to_a}"
  puts
  puts "LEVEL2_SPIRALS = #{LEVEL2_SPIRALS}"
  puts "LEVEL2_SPIRALS_BEFORE_INFLECTION = #{LEVEL2_SPIRALS_BEFORE_INFLECTION}"
  puts "LEVEL2_BARS_PER_SPIRAL_SERIE        = #{LEVEL2_BARS_PER_SPIRAL_SERIE.to_a}"
  puts
  puts "LEVEL1_TURNS = #{LEVEL1_TURNS}"
  puts "LEVEL1_TURNS_BEFORE_INFLECTION = #{LEVEL1_TURNS_BEFORE_INFLECTION}"
  puts "LEVEL1_BARS_PER_TURN = #{LEVEL1_BARS_PER_TURN}"
  puts

  def initialize(real_clock: false, do_voices_log: true)
    super

    # Compute level 1 spiral
    #
    level1_matrix = calculate_level1_matrix
    @probe.render_matrix(level1_matrix, color: 0xa0a0a0)

    level1_matrix_quantized_timed_series_array = quantize_matrix(level1_matrix)

    # level1_matrix_quantized_timed_series_array has only 1 element because level 1 spiral has no time folding

    @level1_matrix_quantized_timed_series = level1_matrix_quantized_timed_series_array.first
  end

  private def calculate_level1_matrix
    length = LEVEL1_TURNS * LEVEL1_BARS_PER_TURN

    inflection_length = LEVEL1_TURNS_BEFORE_INFLECTION * LEVEL1_BARS_PER_TURN

    info "level 1 turns = #{LEVEL1_TURNS}"
    info "level 1 bars_per_turn = #{LEVEL1_BARS_PER_TURN}"
    info "level 1 length = #{length}"
    info "level 1 inflection_turns = #{LEVEL1_TURNS_BEFORE_INFLECTION}"
    info "level 1 inflection_length = #{inflection_length}"

    matrix1a = MatrixOperations.spiral(LEVEL1_TURNS_BEFORE_INFLECTION, length: inflection_length, radius_end: 10, resolution: 720)
    matrix1b = MatrixOperations.spiral(LEVEL1_TURNS - LEVEL1_TURNS_BEFORE_INFLECTION, z_start: inflection_length, length: (length - inflection_length), radius_start: 10, resolution: 720)

    matrix1a.vstack(matrix1b)
  end

  private def quantize_matrix(matrix)
    # Quantization of the matrix curves to MIDI compatible steps
    #
    matrix_p_array = matrix.to_p(time_dimension: 2, keep_time: true)

    matrix_quantized_timed_series_array = quantized_timed_series_of_p_array(matrix_p_array, quantization_step: 0.5)

    matrix_quantized_timed_series_array
  end

  private def quantized_timed_series_of_p_array(p_array, quantization_step: 0.1)
    p_array.collect do |curve|
      curve.to_timed_serie(time_start_component: 2, base_duration: 1)
           .flatten_timed
           .split.instance
           .to_a
           .tap { |_| _.delete_at(2) } # we don't want time dimension itself to be quantized
           .collect do |_|
        # _.quantize(step: quantization_step, predictive: true, stops: false)
        _.quantize(step: quantization_step, predictive: true, stops: false)
         .anticipate do |_, c, n|
          if n
            c.clone.tap { |_| _[:next_value] = (c[:value].nil? || c[:value] == n[:value]) ? nil : n[:value] }
          else
            c
          end
        end
      end.then { |_| TIMED_UNION(*_) }
    end
  end

  def run(only_draw_matrixes: nil)
    super() do
      next if only_draw_matrixes

      @sequencer.at 1 do
        @turns = 0

        every_turn = @sequencer.every LEVEL1_BARS_PER_TURN do
          @logger.info "turn #{@turns}"
          @turns += 1
        end

        coordinates = [nil] * 3

        level1_play = @sequencer.play_timed @level1_matrix_quantized_timed_series do |values, duration:|

          2.times { |i| coordinates[i] = values[i] if values[i] }
          coordinates[2] = @sequencer.position - 1r

          @probe.render_point('first level', coordinates, color: 0x0fffff)

          @level1_x, @level1_y, @level1_z = coordinates
        end

        level1_play.after do
          @logger.info "stopping"
          every_turn.stop
        end
      end
    end
  end
end

EspiralV3.new.run(only_draw_matrixes: true)

