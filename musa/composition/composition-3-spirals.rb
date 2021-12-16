require_relative 'composition-2-instrumentation'

require_relative '../lib/matrix-operations'
require_relative '../lib/matrix-custom-operations'
require_relative '../lib/boxing'

using Musa::Extension::Matrix

class CompositionWithSpirals < CompositionWithInstrumentation
  extend Musa::Series
  include Musa::Series

  CENTER_PITCH = 72
  BPM_MIN = 70
  BPM_RANGE = 120

  LEVEL2_SPIRALS = 13 # fibonacci serie 1 1 2 3 5 8 _13_ 21 34
  LEVEL2_SPIRALS_BEFORE_INFLECTION = 8

  LEVEL2_TURN_RADIUS_DELTA_SERIE = S(4).repeat

  LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE =
    FIBO().max_size(LEVEL2_SPIRALS_BEFORE_INFLECTION) +
    FIBO().skip(LEVEL2_SPIRALS - LEVEL2_SPIRALS_BEFORE_INFLECTION - 1).max_size(LEVEL2_SPIRALS - LEVEL2_SPIRALS_BEFORE_INFLECTION).reverse

  LEVEL3_BARS_PER_TURN_SERIE =
    (FIBO().max_size(LEVEL2_SPIRALS_BEFORE_INFLECTION).reverse +
      FIBO().max_size(LEVEL2_SPIRALS - LEVEL2_SPIRALS_BEFORE_INFLECTION))
    .map { |_| _ * 2 }

  LEVEL3_RADIUS_FACTOR_SERIE_I = S(7).repeat.i

  LEVEL3_SPIRAL_A_TURNS_SERIE_I = S(3).repeat.i
  LEVEL3_SPIRAL_A_LENGTH_SERIE_I = S(3).repeat.i

  LEVEL3_SPIRAL_B_TURNS_SERIE_I = S(2).repeat.i
  LEVEL3_SPIRAL_B_LENGTH_SERIE = S(2).repeat.i

  LEVEL2_BARS_PER_SPIRAL_SERIE = A(LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE, LEVEL3_BARS_PER_TURN_SERIE).map { |turns, bars| turns * bars }

  LEVEL2_ROTATE_Z_OFFSET_SERIE_I = S(1.25).repeat.i

  LEVEL1_ASKED_TURNS = 21 # fibonacci serie 1 1 2 3 5 8 13 _21_ 34
  LEVEL1_TURNS_BEFORE_INFLECTION = 13
  LEVEL1_BARS_PER_TURN = LEVEL2_BARS_PER_SPIRAL_SERIE.to_a.sum / LEVEL1_ASKED_TURNS
  LEVEL1_TURNS = LEVEL2_BARS_PER_SPIRAL_SERIE.to_a.sum / LEVEL1_BARS_PER_TURN.to_f
  LEVEL1_MAX_RADIUS = 10

  LEVEL3_ARTICULATION_GROUP_ROTATION_SIZE = 5.0

  def initialize(realtime: false, render3d: nil, do_voices_log: true, draw_level1: true, draw_level2: true, draw_level3: true)
    super(realtime: realtime, render3d: render3d, do_voices_log: do_voices_log)

    info "SPIRALS CONFIGURATION"
    info "---------------------"
    info "CENTER_PITCH                     = #{CENTER_PITCH}"
    info "BPM_MIN                          = #{BPM_MIN}"
    info "BPM_RANGE                        = #{BPM_RANGE}"
    info ''
    info "LEVEL1_ASKED_TURNS               = #{LEVEL1_ASKED_TURNS}"
    info "LEVEL1_TURNS                     = #{LEVEL1_TURNS}"
    info "LEVEL1_TURNS_BEFORE_INFLECTION   = #{LEVEL1_TURNS_BEFORE_INFLECTION}"
    info "LEVEL1_BARS_PER_TURN             = #{LEVEL1_BARS_PER_TURN}"
    info "LEVEL1_MAX_RADIUS                = #{LEVEL1_MAX_RADIUS}"
    info ''
    info "LEVEL2_SPIRALS                   = #{LEVEL2_SPIRALS}"
    info "LEVEL2_SPIRALS_BEFORE_INFLECTION = #{LEVEL2_SPIRALS_BEFORE_INFLECTION}"
    # info "LEVEL2_TURN_RADIUS_DELTA         = #{LEVEL2_TURN_RADIUS_DELTA}"
    info "LEVEL2_BARS_PER_SPIRAL_SERIE     = #{LEVEL2_BARS_PER_SPIRAL_SERIE.to_a}"
    # info "LEVEL2_ROTATE_Z_OFFSET           = #{LEVEL2_ROTATE_Z_OFFSET}"
    info ''
    info "LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE= #{LEVEL3_TURNS_BY_LEVEL2_TURN_SERIE.to_a}"
    info "LEVEL3_BARS_PER_TURN_SERIE       = #{LEVEL3_BARS_PER_TURN_SERIE.to_a}"
    # info "LEVEL3_RADIUS_FACTOR             = #{LEVEL3_RADIUS_FACTOR}"
    # info "LEVEL3_SPIRAL_TURNS_A            = #{LEVEL3_SPIRAL_A_TURNS}"
    # info "LEVEL3_SPIRAL_LENGTH_A           = #{LEVEL3_SPIRAL_A_LENGTH}"
    # info "LEVEL3_SPIRAL_TURNS_B            = #{LEVEL3_SPIRAL_B_TURNS}"
    # info "LEVEL3_SPIRAL_LENGTH_B           = #{LEVEL3_SPIRAL_B_LENGTH}"
    info "LEVEL3_ARTICULATION_GROUP_ROTATION_SIZE = #{LEVEL3_ARTICULATION_GROUP_ROTATION_SIZE}"

    # Compute level 1 spiral
    #
    @level1_matrix = calculate_level1_matrix
    @probe&.render_matrix(@level1_matrix, color: 0xa0a0a0) if draw_level1

    # @level1_matrix_timed_serie has only 1 element because level 1 spiral has no time folding

    @level1_matrix_timed_serie = quantized_timed_series_of_matrix(@level1_matrix).first # TODO: determinar valores máximos de x,y y la cuantizaciónlevel1_matrix_timed_series

    debug "calculating level 1 box..."
    @level1_box = Boxing.new(@level1_matrix_timed_serie)
    info "level 1 #{@level1_box}"

    # Compute level 2 spirals
    #
    @level2_matrix = calculate_level2_matrix
    @probe&.render_matrix(@level2_matrix, color: 0x00f00a) if draw_level2

    # @level2_matrix_timed_series has several timed series because level 2 has time folding spirals

    @level2_matrix_timed_series = quantized_timed_series_of_matrix(@level2_matrix) # TODO: determinar valores máximos de x,y y la cuantización

    debug "calculating level 2 box..."
    @level2_box = Boxing.new(@level2_matrix_timed_series)
    info "level 2 #{@level2_box}"

    # Compute level 3 spirals
    #
    @level3_matrix_array = calculate_level3_matrix_array(@level2_matrix)

    if draw_level3
      @level3_matrix_array.each do |level3_matrix|
        @probe&.render_matrix(level3_matrix, color: 0xf0f000)
      end
    end

    # level3

    @level3_quantized_matrix_timed_series_array = @level3_matrix_array.collect.with_index do |level3_matrix|
      quantized_timed_series_of_matrix(level3_matrix)
    end

    debug "calculating level 3 box..."

    @level3_inner_boxes = @level3_quantized_matrix_timed_series_array.collect { |_| Boxing.new(_) }
    @level3_box = Boxing.new(@level3_inner_boxes)

    info "level 3 #{@level3_box}"

    info "level 2 matrix has #{@level2_matrix_timed_series.size} timed series (#{@level3_matrix_array.size} level 3 matrixes)"
  end

  private def calculate_level1_matrix
    length = LEVEL1_TURNS * LEVEL1_BARS_PER_TURN

    inflection_length = LEVEL1_TURNS_BEFORE_INFLECTION * LEVEL1_BARS_PER_TURN

    info "level 1 turns = #{LEVEL1_TURNS}"
    info "level 1 bars_per_turn = #{LEVEL1_BARS_PER_TURN}"
    info "level 1 length = #{length}"
    info "level 1 inflection_turns = #{LEVEL1_TURNS_BEFORE_INFLECTION}"
    info "level 1 inflection_length = #{inflection_length}"

    matrix1a = MatrixOperations.spiral(LEVEL1_TURNS_BEFORE_INFLECTION, length: inflection_length, radius_end: LEVEL1_MAX_RADIUS, resolution: 720)
    matrix1b = MatrixOperations.spiral(LEVEL1_TURNS - LEVEL1_TURNS_BEFORE_INFLECTION, z_start: inflection_length, length: (length - inflection_length), radius_start: LEVEL1_MAX_RADIUS, resolution: 720, last: true)

    end_point_correction = matrix1b.row(matrix1b.row_count - 1).normalize

    matrix1a.vstack(matrix1b) * MatrixOperations.rotate_z_to(end_point_correction)
  end

  private def calculate_level2_matrix
    spiral_lengths_serie = LEVEL2_BARS_PER_SPIRAL_SERIE.i
    delta_radius_serie = LEVEL2_TURN_RADIUS_DELTA_SERIE.i

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

    # @probe.render_matrix(rotation_target_spiral, color: 0xffffff)

    accumulated_length = 0

    while spiral_length = spiral_lengths_serie.next_value

      delta_radius = round < LEVEL2_SPIRALS_BEFORE_INFLECTION ? delta_radius_serie.next_value : -delta_radius_serie.next_value

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
      rotate_z = LEVEL2_ROTATE_Z_OFFSET_SERIE_I.next_value - (rotate_x**2 + rotate_y**2)**(1/2r)

      info "level 2 spiral #{round} rotating to: x = #{rotate_x} y = #{rotate_y} z = #{rotate_z} (z offset #{LEVEL2_ROTATE_Z_OFFSET_SERIE_I.current_value})"

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
    level2_matrix_p_array = level2_matrix.to_p(time_dimension: 2, keep_time: true).collect

    level2_matrix_p_array.with_index do |curve_p, i|

      curve_timed_serie_a = curve_p.to_timed_serie(base_duration: 1).to_a

      start = Vector[*curve_timed_serie_a.first[:value]]
      finish = Vector[*curve_timed_serie_a.last[:value]]

      direct = (finish - start) / (finish - start).magnitude
      perpendicular = direct.cross(Vector[0, 0, 1])

      rotate_to = direct * (level2_matrix_p_array.size - i - 1) + perpendicular * i

      center = (start + finish) / 2

      duration = curve_timed_serie_a.last[:time] - curve_timed_serie_a.first[:time]

      radius = (1 + LEVEL3_RADIUS_FACTOR_SERIE_I.next_value * (start[1] - @level2_box.y_min) / @level2_box.y_range).round.to_i

      info "calculating level 3 matrix #{i}: radius #{radius} duration #{duration}"

      part_a_length = LEVEL3_SPIRAL_A_LENGTH_SERIE_I.next_value

      spiral = MatrixOperations.spiral(LEVEL3_SPIRAL_A_TURNS_SERIE_I.next_value,
                                       radius_start: 0,
                                       radius_end: radius,
                                       length: part_a_length,
                                       resolution: 360).vstack(
                                         MatrixOperations.spiral(LEVEL3_SPIRAL_B_TURNS_SERIE_I.next_value,
                                                                 radius_start: radius,
                                                                 radius_end: 0,
                                                                 length: LEVEL3_SPIRAL_B_LENGTH_SERIE.next_value,
                                                                 z_start: LEVEL3_SPIRAL_A_LENGTH_SERIE_I.next_value,
                                                                 resolution: 360,
                                                                 last: true))

      spiral.extend(MatrixCustomOperations)

      (spiral.unit_boxed.scale_to(x: radius, y: radius) * MatrixOperations.rotate_z_to(rotate_to))
        .extend(MatrixCustomOperations)
        .scale_to(z: duration)
        .move(center)
        .then do |_|
        Matrix[*_._rows.select { |_| _[2] >= 0 }] # Remove points before time 0

      end.tap do |_|
        info "level 3 curve #{i} starts at #{_.row(0)} finish at #{_.row(_.row_count-1)}"
      end
    end
  end
end

