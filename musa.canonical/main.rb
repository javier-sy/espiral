require_relative 'composition/composition-5-play-notes'

CompositionWithNotesPlaying.new(realtime: true, render3d: false,
                                draw_level1: false, draw_level2: true, draw_level3: true)
                           .run(play: true,
                                draw_level1: false, draw_level2: true, draw_level3: true)

