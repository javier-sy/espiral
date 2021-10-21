class Boxing
  attr_reader :x_min, :x_max, :x_range, :x_middle
  attr_reader :y_min, :y_max, :y_range, :y_middle
  attr_reader :magnitude_max

  def initialize(timed_serie_or_timed_series)
    @magnitude_max = 0.0

    case timed_serie_or_timed_series
    when Musa::Series::Serie
      a = timed_serie_or_timed_series.to_a(restart: true)
      timed_serie_or_timed_series.restart

      only_values = a.map { |_| _[:value] }
      only_x = only_values.map { |_| _[0] }.compact
      only_y = only_values.map { |_| _[1] }.compact

      @x_min, @x_max = only_x.minmax
      @y_min, @y_max = only_y.minmax

      @x_middle = (@x_min + @x_max) / 2r
      @y_middle = (@y_min + @y_max) / 2r

      vector_max = Vector[@x_max, @y_max]
      @magnitude_max = vector_max.magnitude if vector_max.magnitude > @magnitude_max

    when Array
      boxings = timed_serie_or_timed_series.collect { |_| _.is_a?(Boxing) ? _ : Boxing.new(_) }

      @x_min = boxings.collect(&:x_min).min
      @y_min = boxings.collect(&:y_min).min

      @x_max = boxings.collect(&:x_max).max
      @y_max = boxings.collect(&:y_max).max

      @magnitude_max = boxings.collect(&:magnitude_max).max
    else
      raise ArgumentError, "Unexpected #{timed_serie_or_timed_series.class.name}"
    end

    @x_range = @x_max - @x_min
    @x_middle = (@x_min + @x_max) / 2r

    @y_range = @y_max - @y_min
    @y_middle = (@y_min + @y_max) / 2r
  end

  def to_s
    "Box x: #{@x_min}..#{@x_max} middle #{@x_middle} (range #{@x_range}) y: #{@y_min}..#{@y_max} middle #{@y_middle} (range #{@y_range}) magnitude #{@magnitude_max}"
  end
end
