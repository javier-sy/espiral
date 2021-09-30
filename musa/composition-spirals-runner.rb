require_relative 'composition-spirals'

require_relative 'matrix-operations'
require_relative 'matrix-custom-operations'

using Musa::Extension::Matrix

class CompositionWithSpiralsRunner < CompositionWithSpirals
  def initialize(realtime: false, render3d: nil, do_voices_log: true, draw_level1: true, draw_level2: true, draw_level3: true)
    super

    # @level1_matrix_timed_serie has only 1 element because level 1 spiral has no time folding
    #
    @level1_matrix_timed_serie = quantized_timed_series_of_matrix(@level1_matrix).first # TODO: determinar valores máximos de x,y y la cuantizaciónlevel1_matrix_timed_series

    debug "calculating level 1 box..."
    @level1_box = Boxing.new(@level1_matrix_timed_serie)
    info "level 1 #{@level1_box}"

    # @level2_matrix_timed_series has several timed series because level 2 has time folding spirals
    #
    @level2_matrix_timed_series = quantized_timed_series_of_matrix(@level2_matrix) # TODO: determinar valores máximos de x,y y la cuantización

    debug "calculating level 2 box..."
    @level2_box = Boxing.new(@level2_matrix_timed_series)
    info "level 2 #{@level2_box}"

    # level3
    #
    @level3_matrix_timed_series_array = @level3_matrix_array.collect.with_index do |level3_matrix|
      quantized_timed_series_of_matrix(level3_matrix)
    end

    debug "calculating level 3 box..."
    @level3_box = Boxing.new(@level3_matrix_timed_series_array.collect { |_| Boxing.new(_) })
    info "level 3 #{@level3_box}"

    info "level 2 matrix has #{@level2_matrix_timed_series.size} timed series (#{@level3_matrix_array.size} level 3 matrixes)"
  end

  def run(play: false, draw_level1: true, draw_level2: true, draw_level3: true)
    super() do
      next unless play

      info "Preparing players...", force: true

      every_turn = nil
      @sequencer.at 1 do
        @turns = 0

        every_turn = @sequencer.every LEVEL1_BARS_PER_TURN do
          info "turn #{@turns}"
          @turns += 1
        end
      end

      level1_play = @sequencer.play_timed @level1_matrix_timed_serie, at: 1 do |values, duration:|
        @level1_x = values[0] if values[0]
        @level1_y = values[1] if values[1]
        @level1_z = @sequencer.position - 1r

        @probe&.render_point('first level', [@level1_x, @level1_y, @level1_z], color: 0x0fffff) if draw_level1
      end

      level1_play.after do
        info "stopping level 1"
        every_turn.stop
      end

      @level2_x = []
      @level2_y = []
      @level2_z = []
      @level2_active = []

      level2_plays = @level2_matrix_timed_series.collect.with_index do |level2_matrix_quantized_timed_serie, i|
        @sequencer.play_timed level2_matrix_quantized_timed_serie, at: 1 do |values, duration:|
          unless @level2_active[i]
            @level2_active[i] = true
            info "starting level 2 curve #{i} (#{@level2_active.select {|_|_}.count} actives on level 2)"

            @clock.bpm = 80 + (90 * (@level1_y - @level1_box.y_min) / @level1_box.y_range).round
            info "setting clock bpm to #{@clock.bpm.to_f}", force: true
          end

          if @level2_x[i].nil? && values[0].nil?
            error "level 2 #{i}: @level2_x[i].nil? && values[0].nil?"
          end

          @level2_x[i] = values[0] if values[0]
          @level2_y[i] = values[1] if values[1]
          @level2_z[i] = @sequencer.position - 1r

          render_to_midi_level2 level2: i, values: [@level2_x[i], @level2_y[i]], duration: duration

          @probe&.render_point("second level line #{i}", [@level2_x[i], @level2_y[i], @level2_z[i]], color: 0x00a0a0) if draw_level2
        end
      end

      level2_plays.each.with_index do |level2_play, i|
        level2_play.after do
          @level2_active[i] = false
          info "finished level 2 curve #{i} (remaining #{@level2_active.select {|_|_}.count} actives on level 2)"
        end
      end

      @level3_x = []
      @level3_y = []
      @level3_z = []
      @level3_active = []

      level3_plays_array = @level3_matrix_timed_series_array.collect.with_index do |level3_matrix_quantized_timed_series, level2_i|
        level3_matrix_quantized_timed_series.collect.with_index do |level3_matrix_quantized_timed_serie, i|
          @sequencer.play_timed level3_matrix_quantized_timed_serie, at: 1 do |values, duration:|
            @level3_x[level2_i] ||= []
            @level3_y[level2_i] ||= []
            @level3_z[level2_i] ||= []

            @level3_active[level2_i] ||= []

            unless @level3_active[level2_i][i]
              @level3_active[level2_i][i] = true
              info "starting level 3 curve #{level2_i}-#{i} (#{@level3_active.flatten.select {|_|_}.count} actives on level 3)"
            end

            @level3_x[level2_i][i] = values[0] if values[0]
            @level3_y[level2_i][i] = values[1] if values[1]
            @level3_z[level2_i][i] = @sequencer.position - 1r

            @probe&.render_point("second level curve #{level2_i} third level curve #{i}", [@level3_x[level2_i][i], @level3_y[level2_i][i], @level3_z[level2_i][i]], color: 0xffa0a0) if draw_level3

            render_to_midi_level3 level2: level2_i, level3: i, values: [@level3_x[level2_i][i], @level3_y[level2_i][i]], duration: duration
          end
        end
      end

      level3_plays_array.size.times do |level2_i|
        level3_plays_array[level2_i].each.with_index do |level3_play, i|
          level3_play.after do
            @level3_active[level2_i][i] = false
            info "finished level 3 #{level2_i}-#{i} (remaining #{@level3_active.flatten.select {|_|_}.count} actives on level 3)"
          end
        end
      end
    end

    info "... and let's go!", force: true
  end

  protected def render_to_midi_level2(level2:, values:, duration:)
    info "rendering level 2 #{level2} values #{values} duration #{duration}"
  end

  protected def render_to_midi_level3(level2:, level3:, values:, duration:)
    info "rendering level 3 #{level2}-#{level3} values #{values} duration #{duration}"
  end

  private def quantized_timed_series_of_matrix(matrix, quantization_step = 0.5)
    # Quantization of the matrix curves to MIDI compatible steps
    #
    matrix_p_array = matrix.to_p(time_dimension: 2, keep_time: true)

    quantized_timed_series_of_p_array(matrix_p_array, quantization_step: quantization_step)
  end

  private def timed_series_of_matrix(matrix)
    timed_series_of_p_array(matrix.to_p(time_dimension: 2, keep_time: true))
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

  private def timed_series_of_p_array(p_array)
    p_array.collect do |curve|
      curve.to_timed_serie(time_start_component: 2, base_duration: 1)
           .flatten_timed
    end
  end
end

class Boxing
  attr_reader :x_min, :x_max, :x_range
  attr_reader :y_min, :y_max, :y_range

  def initialize(timed_serie_or_timed_series)
    case timed_serie_or_timed_series
    when Musa::Series::Serie
      a = timed_serie_or_timed_series.to_a(restart: true)
      timed_serie_or_timed_series.restart

      only_values = a.map { |_| _[:value] }
      only_x = only_values.map { |_| _[0] }.compact
      only_y = only_values.map { |_| _[1] }.compact

      @x_min, @x_max = only_x.minmax
      @y_min, @y_max = only_y.minmax

    when Array
      boxings = timed_serie_or_timed_series.collect { |_| _.is_a?(Boxing) ? _ : Boxing.new(_) }

      @x_min = boxings.collect(&:x_min).min
      @y_min = boxings.collect(&:y_min).min

      @x_max = boxings.collect(&:x_max).max
      @y_max = boxings.collect(&:y_max).max
    else
      raise ArgumentError, "Unexpected #{timed_serie_or_timed_series.class.name}"
    end

    @x_range = @x_max - @x_min
    @y_range = @y_max - @y_min
  end

  def to_s
    "Box x: #{@x_min}..#{@x_max} (range #{@x_range} y: #{@y_min}..#{@y_max} (range #{@y_range})"
  end
end

