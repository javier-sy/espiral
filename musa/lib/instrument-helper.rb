module InstrumentHelper
  protected def pitch(string)
    base = { c: 0, d: 2, e: 4, f: 5, g: 7, a: 9, b: 11 }[string[0].downcase.to_sym]
    accidental = case string[1]
                 when '#'
                   1
                 when '_'
                   -1
                 else
                   0
                 end
    octave = string[-1].to_i

    60 + 12 * (octave - 4) + base + accidental
  end
end