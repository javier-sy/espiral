require_relative 'espiral-instrumentation-3'

require_relative 'matrix-operations'
require_relative 'matrix-custom-operations'

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

  LEVEL1_ASKED_TURNS = 21 # fibonacci serie 1 1 2 3 5 8 13 _21_ 34
  LEVEL1_TURNS_BEFORE_INFLECTION = 13
  LEVEL1_BARS_PER_TURN = LEVEL2_BARS_PER_SPIRAL_SERIE.to_a.sum / LEVEL1_ASKED_TURNS
  LEVEL1_TURNS = LEVEL2_BARS_PER_SPIRAL_SERIE.to_a.sum / LEVEL1_BARS_PER_TURN.to_f

  puts "CONFIGURATION"
  puts "-------------"
  puts "LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE = #{LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE.to_a}"
  puts "LEVEL3_BARS_PER_TURN_SERIE        = #{LEVEL3_BARS_PER_TURN_SERIE.to_a}"
  puts
  puts "LEVEL2_SPIRALS = #{LEVEL2_SPIRALS}"
  puts "LEVEL2_SPIRALS_BEFORE_INFLECTION = #{LEVEL2_SPIRALS_BEFORE_INFLECTION}"
  puts "LEVEL2_BARS_PER_SPIRAL_SERIE        = #{LEVEL2_BARS_PER_SPIRAL_SERIE.to_a}"
  puts
  puts "LEVEL1_ASKED_TURNS = #{LEVEL1_ASKED_TURNS}"
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

    level2_matrix = calculate_level2_matrix
    @probe.render_matrix(level2_matrix, color: 0x00f00a)

    level3_matrix_array = calculate_level3_matrix_array(level2_matrix)

    level3_matrix_array.each do |level3_matrix|
      @probe.render_matrix(level3_matrix, color: 0xf0f000)
    end

    level1_matrix_quantized_timed_series_array = quantize_matrix(level1_matrix) # TODO: determinar valores máximos de x,y y la cuantización
    level2_matrix_quantized_timed_series_array = quantize_matrix(level2_matrix) # TODO: determinar valores máximos de x,y y la cuantización

    # level1_matrix_quantized_timed_series_array has only 1 element because level 1 spiral has no time folding
    #
    @level1_matrix_quantized_timed_serie = level1_matrix_quantized_timed_series_array.first

    # level2_matrix_quantized_timed_series_array has several timed series because level 2 has time folding spirals
    #
    @level2_matrix_quantized_timed_series = level2_matrix_quantized_timed_series_array

    # level3
    #
    @level3_matrix_quantized_timed_series_array = level3_matrix_array.collect.with_index do |level3_matrix|
      quantize_matrix(level3_matrix)
    end


    info "level 2 matrix has #{@level2_matrix_quantized_timed_series.size} timed series (#{level3_matrix_array.size} level 3 matrixes)"
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
    matrix1b = MatrixOperations.spiral(LEVEL1_TURNS - LEVEL1_TURNS_BEFORE_INFLECTION, z_start: inflection_length, length: (length - inflection_length), radius_start: 10, resolution: 720, last: true)

    end_point_correction = matrix1b.row(matrix1b.row_count - 1).normalize

    matrix1a.vstack(matrix1b) * MatrixOperations.rotate_z_to(end_point_correction)
  end

  private def calculate_level2_matrix
    spiral_lengths_serie = LEVEL2_BARS_PER_SPIRAL_SERIE.i

    last_radius = 0
    last_point = Vector[0.0, 0.0, 0.0]
    spirals = []
    round = 0

    remaining_length = LEVEL2_BARS_PER_SPIRAL_SERIE.skip(LEVEL2_SPIRALS_BEFORE_INFLECTION).to_a.sum
    inflection_length = LEVEL2_BARS_PER_SPIRAL_SERIE.max_size(LEVEL2_SPIRALS_BEFORE_INFLECTION).to_a.sum

    rotation_target_spiral =
      # We use inflection length reversed because we will reverse the spiral at the end
      #
      MatrixOperations.spiral(1,
                              length: remaining_length,
                              radius_end: 1,
                              clockwise: false)
                      .vstack(MatrixOperations.spiral(1,
                                                      length: inflection_length,
                                                      z_start: remaining_length,
                                                      radius_start: 1,
                                                      radius_end: 0,
                                                      clockwise: false,
                                                      last: true))

    @probe.render_matrix(rotation_target_spiral, color: 0xffffff)

    accumulated_length = 0

    while spiral_length = spiral_lengths_serie.next_value

      delta_radius = round < 8 ? 1 : -1

      info "level 2 processing spiral #{round} of length #{spiral_length} with radius_start #{last_radius} radius_end #{last_radius + delta_radius}"

      spiral = MatrixOperations.spiral(radius_start: last_radius,
                                       radius_end: (last_radius += delta_radius),
                                       resolution: 360,
                                       last: spiral_lengths_serie.peek_next_value.nil?)

      spiral.extend MatrixCustomOperations

      accumulated_length += spiral_length

      # Rotation vector corresponds to the vector from origin to the point of the spiral on this moment
      # but with z rotation altered to increase the folding.
      #
      row_index = rotation_target_spiral._rows.find_index { |_, _, z| z > accumulated_length }

      rotate_x, rotate_y, = rotation_target_spiral._rows[row_index]

      rotate_x ||= 0.0
      rotate_y ||= 0.0
      rotate_z = 1.25 - (rotate_x**2 + rotate_y**2)**(1/2r)

      info "level 2 spiral #{round} rotating to: x = #{rotate_x} y = #{rotate_y} z = #{rotate_z}"

      rotated_spiral =
        (spiral.unit_boxed *
         MatrixOperations.rotate_z_to(Vector[rotate_x, rotate_y, rotate_z]))
        .extend(MatrixCustomOperations)
        .scale_end_to_end_only_z_axis_to(spiral_length)
        .scale_to(x: last_radius, y: last_radius)

      info "level 2 spiral #{round} rotated spiral: z length = #{(rotated_spiral.row(rotated_spiral.row_count - 1) - rotated_spiral.row(0))[2]}"

      offset = last_point - rotated_spiral.row(0)

      displaced_rotated_spiral = rotated_spiral + Matrix.rows([offset.to_a] * rotated_spiral.row_count)
      spirals << displaced_rotated_spiral

      last_point = displaced_rotated_spiral.row(displaced_rotated_spiral.row_count - 1)

      round += 1
    end

    end_point = spirals.last.row(spirals.last.row_count - 1)
    end_point_correction = Vector[-end_point[0], -end_point[1], end_point[2]]

    spirals.reduce(:vstack) * MatrixOperations.rotate_z_to(end_point_correction)
  end

  private def calculate_level3_matrix_array(level2_matrix)
    level2_matrix.to_p(time_dimension: 2, keep_time: true).collect.with_index do |curve_p, i|

      curve_timed_serie_a = curve_p.to_timed_serie(base_duration: 1).to_a

      start = Vector[*curve_timed_serie_a.first[:value]]
      finish = Vector[*curve_timed_serie_a.last[:value]]

      rotate_to = finish - start

      duration = curve_timed_serie_a.last[:time] - curve_timed_serie_a.first[:time]

      spiral = MatrixOperations.spiral(3,
                                       radius_start: 0,
                                       radius_end: 3,
                                       length: 3,
                                       resolution: 360).vstack(
                                         MatrixOperations.spiral(2,
                                                                 radius_start: 3,
                                                                 radius_end: 0,
                                                                 length: 2,
                                                                 z_start: 3,
                                                                 resolution: 360,
                                                                 last: true))

      spiral.extend(MatrixCustomOperations)

      (spiral.scale_end_to_end_only_z_axis_to(rotate_to.magnitude) * MatrixOperations.rotate_z_to(rotate_to))
        .extend(MatrixCustomOperations)
        .move(start)
        # .move(Vector[0, 0, start[2]])
        # .add_over_z_axis(curve_timed_serie_a)
        .tap do |_|

        info "level 3 curve #{i} starts at #{_.row(0)} finish at #{_.row(_.row_count-1)}"
      end
    end
  end

  private def quantize_matrix(matrix, quantization_step = 0.5)
    # Quantization of the matrix curves to MIDI compatible steps
    #
    matrix_p_array = matrix.to_p(time_dimension: 2, keep_time: true)

    quantized_timed_series_of_p_array(matrix_p_array, quantization_step: quantization_step)
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

        level1_play = @sequencer.play_timed @level1_matrix_quantized_timed_serie do |values, duration:|
          @level1_x = values[0] if values[0]
          @level1_y = values[1] if values[1]
          @level1_z = @sequencer.position - 1r

          @probe.render_point('first level', [@level1_x, @level1_y, @level1_z], color: 0x0fffff)
        end

        level1_play.after do
          @logger.info "stopping level 1"
          every_turn.stop
        end

        @level2_x = []
        @level2_y = []
        @level2_z = []
        @level2_active = []

        level2_plays = @level2_matrix_quantized_timed_series.collect.with_index do |level2_matrix_quantized_timed_serie, i|

          a = level2_matrix_quantized_timed_serie.to_a(duplicate: true)

          start = a.first[:time]
          duration_x = a.collect { |_| _[:duration][0] || 0.0 }.sum
          duration_y = a.collect { |_| _[:duration][1] || 0.0 }.sum

          info "level 2 curve #{i} starts at #{start} (#{start.to_f}) with durations #{duration_x} #{duration_y}"

          @sequencer.play_timed level2_matrix_quantized_timed_serie do |values, duration:|
            unless @level2_active[i]
              @level2_active[i] = true
              info "starting level 2 curve #{i} (#{@level2_active.select {|_|_}.count} actives on level 2)"
            end

            @level2_x[i] = values[0] if values[0]
            @level2_y[i] = values[1] if values[1]
            @level2_z[i] = @sequencer.position - 1r


            @probe.render_point("second level line #{i}", [@level2_x[i], @level2_y[i], @level2_z[i]], color: 0xffa0a0)
          end
        end

        level2_plays.each.with_index do |level2_play, i|
          level2_play.after do
            @level2_active[i] = false
            @logger.info "finished level 2 curve #{i} (remaining #{@level2_active.select {|_|_}.count} actives on level 2)"
          end
        end

        @level3_x = []
        @level3_y = []
        @level3_z = []
        @level3_active = []

        level3_plays_array = @level3_matrix_quantized_timed_series_array.collect.with_index do |level3_matrix_quantized_timed_series, level2_i|
          level3_matrix_quantized_timed_series.collect.with_index do |level3_matrix_quantized_time_serie, i|
            @sequencer.play_timed level3_matrix_quantized_time_serie do |values, duration:|

              @level3_x[level2_i] ||= []
              @level3_y[level2_i] ||= []
              @level3_z[level2_i] ||= []

              @level3_active[level2_i] ||= []

              unless @level3_active[level2_i][i]
                @level3_active[level2_i][i] = true
                info "starting level 3 #{level2_i}-#{i} (#{@level3_active.flatten.select {|_|_}.count} actives on level 3)"
              end

              @level3_x[level2_i][i] = values[0] if values[0]
              @level3_y[level2_i][i] = values[1] if values[1]
              @level3_z[level2_i][i] = @sequencer.position - 1r

              @probe.render_point("second level line #{level2_i} third level #{i}", [@level3_x[level2_i][i], @level3_y[level2_i][i], @level3_z[level2_i][i]], color: 0xffa0a0)


            end
          end
        end

        level3_plays_array.size.times do |level2_i|
          level3_plays_array[level2_i].each.with_index do |level3_play, i|
            level3_play.after do
              @level3_active[level2_i][i] = false
              @logger.info "finished level 3 #{level2_i}-#{i} (remaining #{@level3_active.flatten.select {|_|_}.count} actives on level 3)"
            end
          end
        end
      end
    end
  end
end

EspiralV3.new.run(only_draw_matrixes: true)

