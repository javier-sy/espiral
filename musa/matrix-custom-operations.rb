module MatrixCustomOperations
  def move(vector)
    new_rows = @rows.collect do |row|
      [row[0] + vector[0], row[1] + vector[1], row[2] + vector[2]]
    end

    Matrix.rows(new_rows).extend(MatrixCustomOperations)
  end

  def add_over_z_axis(timed_serie_a)
    @rows.collect do |point|
      target_i = timed_serie_a.find_index { |timed_element| timed_element[:value][2] > point[2] }
      target_i ||= timed_serie_a.size - 1

      target_i_pre = target_i - 1 if target_i > 0
      target_i_pre ||= target_i

      target_current = timed_serie_a[target_i][:value]
      target_pre = timed_serie_a[target_i_pre][:value]

      diff = 3.times.collect { |i| target_current[i] - target_pre[i] }

      offset = diff[2].zero? ? 0 : (point[2] - target_pre[2]) / diff[2]

      [point[0] + target_pre[0] + diff[0] * offset,
       point[1] + target_pre[1] + diff[1] * offset,
       point[2]]
    end
    .then do |new_rows|
      Matrix.rows(new_rows).extend(MatrixCustomOperations)
    end
  end

  def unit_boxed
    min = []
    max = []
    diff = []

    column_count.times do |i|
      a = column(i).to_a
      min[i], max[i] = a.minmax
      diff[i] = max[i] - min[i]
    end

    new_rows = @rows.collect do |row|
      column_count.times.collect do |i|
        (row[i] - min[i]) / diff[i] - 0.5
      end
    end

    Matrix.rows(new_rows).extend(MatrixCustomOperations)
  end

  def scale_end_to_end_only_z_axis_to(length)
    first_z = row(0)[2]
    last_z = row(row_count - 1)[2]

    factor = length / (last_z - first_z) # .abs

    new_rows = @rows.collect do |row|
      [row[0], row[1], row[2] * factor]
    end

    Matrix.rows(new_rows).extend(MatrixCustomOperations)
  end

  def scale_end_to_end_axis_z_to(length)
    first_z = row(0)[2]
    last_z = row(row_count - 1)[2]

    factor = length / (last_z - first_z) # .abs

    new_rows = @rows.collect do |row|
      [row[0] * factor, row[1] * factor, row[2] * factor]
    end

    Matrix.rows(new_rows).extend(MatrixCustomOperations)
  end

  def scale_to(x: nil, y: nil, z: nil)
    length = [x, y, z]

    min = []
    max = []
    diff = []

    column_count.times do |i|
      a = column(i).to_a
      min[i], max[i] = a.minmax
      diff[i] = max[i] - min[i]
    end

    factor = column_count.times.collect do |i|
      if length[i]
        length[i] / diff[i]
      else
        1.0
      end
    end

    new_rows = @rows.collect do |row|
      [row[0] * factor[0], row[1] * factor[1], row[2] * factor[2]]
    end

    Matrix.rows(new_rows).extend(MatrixCustomOperations)
  end
end
