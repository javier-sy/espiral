class MatrixOperations
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