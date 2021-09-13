require 'matrix'

class MatrixOperations
  def self.spiral(turns = 1, z_start: 0, length: 1, radius_start: 0, radius_end: 1, resolution: 360, clockwise: true, last: false)
    steps = turns.to_f * resolution.round

    radius = radius_start.to_f
    radius_step = (radius_end.to_f - radius_start.to_f) / steps

    z = z_start.to_f
    z_step = length.to_f / steps

    effective_steps = steps - (last ? 0 : 1)

    Matrix[
      *(0..effective_steps).collect do |step|
        effective_step = clockwise ? -step : step

        [Math.sin(2 * Math::PI * effective_step / resolution) * radius,
         Math.cos(2 * Math::PI * effective_step / resolution) * radius,
         z].tap do
          radius += radius_step
          z += z_step
        end
      end]
  end


  # https://en.wikipedia.org/wiki/Transformation_matrix
  #
  def self.rotation(a, x, y, z)
    mod = (x**2r + y**2r + z**2r) ** (1/2r)

    l = x / mod
    m = y / mod
    n = z / mod

    Matrix[
      [l*l*(1-Math.cos(a))+Math.cos(a),  m*l*(1-Math.cos(a))-n*Math.sin(a),  n*l*(1-Math.cos(a))+m*Math.sin(a)],
      [l*m*(1-Math.cos(a))+n*Math.sin(a), m*m*(1-Math.cos(a))+Math.cos(a), n*m*(1-Math.cos(a))-l*Math.sin(a)],
      [l*n*(1-Math.cos(a))-m*Math.sin(a), m*n*(1-Math.cos(a))+l*Math.sin(a), n*m*(1-Math.cos(a))+Math.cos(a)] ]
  end

  def self.rotate_z_to(x, y, z)
    v1 = Vector[0, 0, 1]
    t = Vector[x, y, z].normalize

    angle = Math.acos(t.dot(v1))
    axis = v1.cross(t)

    if axis.zero?
      Matrix.identity(3)
    else
      axis = axis.normalize
      rotation(angle, axis[0], axis[1], axis[2])
    end
  end

  def self.reflection(a, b, c)
    Matrix[
        [1r-2*a**2, -2r*a*b, -2r*a*c],
        [-2r*a*b, 1r-2*b**2, -2*b*c],
        [-2*a*c, -2*b*c, 1-2*c**2] ]
  end
end