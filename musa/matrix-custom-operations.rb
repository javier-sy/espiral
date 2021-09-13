module MatrixCustomOperations
  def move(x, y, z)
    new_rows = @rows.collect do |row|
      [row[0] + x, row[1] + y, row[2] + z]
    end

    Matrix.rows(new_rows).extend(MatrixCustomOperations)
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

  def scale_end_to_end_only_axis_z_to(length)
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
