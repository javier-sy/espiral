require 'matrix'

class MatrixOperations
  # def self.spiral(resolution)
  #   rows = []
  #   r = 0.0
  #   (0..resolution-1).each do |z|
  #     x = Math.sin(r) * z / 70.0
  #     y = Math.cos(r) * z / 70.0
  #     rows << [x, y, z / 20.0]
  #     r += 0.1
  #   end
  #
  #   Matrix[*rows]
  # end

  def self.spiral(turns = 1, z_start: 0, length: 1, radius_start: 0, radius_end: 1, resolution: 360)
    steps = turns.to_f * resolution.round

    radius = radius_start.to_f
    radius_step = (radius_end.to_f - radius_start.to_f) / steps

    z = z_start.to_f
    z_step = length.to_f / steps

    Matrix[*(0..steps - 1).collect do |step|
      [Math.sin(2 * Math::PI * step / resolution) * radius,
       Math.cos(2 * Math::PI * step / resolution) * radius,
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

  def self.reflection(a, b, c)
    Matrix[
        [1r-2*a**2, -2r*a*b, -2r*a*c],
        [-2r*a*b, 1r-2*b**2, -2*b*c],
        [-2*a*c, -2*b*c, 1-2*c**2] ]
  end
end