require_relative 'composition-spirals'

class CompositionWithNotesPlaying < CompositionWithSpirals
  protected def render_to_midi(level2:, level3:, values:, duration:)
    super

  end
end

CompositionWithNotesPlaying.new.run(only_draw_matrixes: true)

